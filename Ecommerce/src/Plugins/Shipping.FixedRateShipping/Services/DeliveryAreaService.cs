using Grand.Business.Core.Interfaces.Common.Configuration;
using NetTopologySuite;
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;
using NetTopologySuite.Features;
using Newtonsoft.Json;
using Shipping.FixedRateShipping.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Shipping.FixedRateShipping.Services;

public class DeliveryAreaService : IDeliveryAreaService
{
    private readonly ISettingService _settingService;
    private readonly ShippingFixedRateSettings _shippingFixedRateSettings;
    
    public DeliveryAreaService(
        ISettingService settingService,
        ShippingFixedRateSettings shippingFixedRateSettings)
    {
        _settingService = settingService;
        _shippingFixedRateSettings = shippingFixedRateSettings;
    }

    public async Task<DeliveryArea> GetMatchingDeliveryArea(string shippingMethodId, double latitude, double longitude)
    {
        var deliveryAreas = await GetDeliveryAreas(shippingMethodId);
        if (!deliveryAreas.Any())
            return null;
            
        var geometryFactory = NtsGeometryServices.Instance.CreateGeometryFactory(srid: 4326);
        var point = geometryFactory.CreatePoint(new Coordinate(longitude, latitude));
        
        foreach (var deliveryArea in deliveryAreas)
        {
            try
            {
                if (string.IsNullOrEmpty(deliveryArea.GeoJsonData))
                    continue;
                    
                var geometry = ParseGeoJson(deliveryArea.GeoJsonData);
                if (geometry is LineString { IsClosed: true } or Polygon)
                {
                    var factory = new GeometryFactory();
                    var polygon = factory.CreatePolygon(geometry.Coordinates);
                    bool contains = polygon.Contains(point);
                    bool intersects = polygon.Intersects(point);
                    bool within = point.Within(polygon);
                    bool coveredBy = point.CoveredBy(polygon);
                    bool touches = polygon.Touches(point);
                    double distance = polygon.Distance(point);
                    bool isInside = coveredBy || contains || (distance == 0);
                    if (isInside)
                        return deliveryArea;
                }
                
            }
            catch (Exception)
            {
                // Skip invalid geometries
                continue;
            }
        }
        
        return null;
    }

    public Task<IList<DeliveryArea>> GetDeliveryAreas(string shippingMethodId)
    {
        IList<DeliveryArea> result = new List<DeliveryArea>();
        
        if (_shippingFixedRateSettings.DeliveryAreas != null && 
            _shippingFixedRateSettings.DeliveryAreas.ContainsKey(shippingMethodId))
        {
            result = _shippingFixedRateSettings.DeliveryAreas[shippingMethodId];
        }
            
        return Task.FromResult(result);
    }

    public async Task SaveDeliveryArea(string shippingMethodId, DeliveryArea deliveryArea)
    {
        if (_shippingFixedRateSettings.DeliveryAreas == null)
            _shippingFixedRateSettings.DeliveryAreas = new Dictionary<string, List<DeliveryArea>>();
            
        if (!_shippingFixedRateSettings.DeliveryAreas.ContainsKey(shippingMethodId))
            _shippingFixedRateSettings.DeliveryAreas[shippingMethodId] = new List<DeliveryArea>();
            
        var existingIndex = _shippingFixedRateSettings.DeliveryAreas[shippingMethodId]
            .FindIndex(x => x.Id == deliveryArea.Id);
            
        if (existingIndex >= 0)
            _shippingFixedRateSettings.DeliveryAreas[shippingMethodId][existingIndex] = deliveryArea;
        else
            _shippingFixedRateSettings.DeliveryAreas[shippingMethodId].Add(deliveryArea);
            
        await _settingService.SaveSetting(_shippingFixedRateSettings);
    }

    public async Task DeleteDeliveryArea(string deliveryAreaId)
    {
        if (_shippingFixedRateSettings.DeliveryAreas == null )
            return;
            
        KeyValuePair<string,List<DeliveryArea>>? existingArea = _shippingFixedRateSettings.DeliveryAreas.FirstOrDefault(x=>x.Value.Exists(e=>e.Id == deliveryAreaId));
        if (existingArea.HasValue)
        {
            var existingIndex = existingArea.Value.Value.FindIndex(x => x.Id == deliveryAreaId);
            if (existingIndex >= 0)
            {
                _shippingFixedRateSettings.DeliveryAreas[existingArea.Value.Key].RemoveAt(existingIndex);
                await _settingService.SaveSetting(_shippingFixedRateSettings);
            }
        }
    }
    
    private Geometry ParseGeoJson(string geoJsonData)
    {
        try
        {
            // Using standard GeoJSON serializer from NetTopologySuite
            var reader = new GeoJsonReader();
            
            try
            {
                // Try to parse as a Feature or FeatureCollection
                var featureCollection = reader.Read<FeatureCollection>(geoJsonData);
                if (featureCollection != null && featureCollection.Count > 0)
                {
                    // For simplicity, just use the first feature's geometry
                    return featureCollection[0].Geometry;
                }
            }
            catch
            {
                // Try parsing as a direct geometry
                return reader.Read<Geometry>(geoJsonData);
            }
            
            return null;
        }
        catch (Exception)
        {
            return null;
        }
    }
}