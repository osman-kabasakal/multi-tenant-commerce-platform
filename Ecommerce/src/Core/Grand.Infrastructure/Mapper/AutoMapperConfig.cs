using AutoMapper;
using AutoMapper.Internal;

namespace Grand.Infrastructure.Mapper;

public static class AutoMapperConfig
{
    public const int MaximumMappingDepth = 32;

    /// <summary>
    /// Build mappings with a per-type recursion bound, including discovered plugin profiles.
    /// </summary>
    public static MapperConfiguration CreateConfiguration(Action<IMapperConfigurationExpression> configure)
    {
        ArgumentNullException.ThrowIfNull(configure);
        return new MapperConfiguration(config =>
        {
            configure(config);
            config.Internal().ForAllMaps((typeMap, expression) =>
                expression.MaxDepth(typeMap.MaxDepth is > 0 and < MaximumMappingDepth
                    ? typeMap.MaxDepth
                    : MaximumMappingDepth));
        });
    }

    /// <summary>
    ///     Mapper
    /// </summary>
    public static IMapper Mapper { get; private set; }

    /// <summary>
    ///     Initialize mapper
    /// </summary>
    /// <param name="config">Mapper configuration</param>
    public static void Init(MapperConfiguration config)
    {
        Mapper = config.CreateMapper();
    }
}