using Grand.Business.Core.Utilities.Catalog;
using Grand.Domain.Blogs;
using Grand.Domain.Catalog;

namespace Widgets.Slider.Services;

public interface ILinkSelectorService
{
    Task<(IList<Category> Categories, int TotalCount)> GetCategories(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="");
    Task<(IList<Product> Products, int TotalCount)> GetProducts(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="");
    Task<(IList<Brand> Brands, int TotalCount)> GetBrands(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="");
    Task<(IList<Collection> Collections, int TotalCount)> GetCollections(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="");
    Task<(IList<BlogPost> BlogPosts, int TotalCount)> GetBlogPosts(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="");
}