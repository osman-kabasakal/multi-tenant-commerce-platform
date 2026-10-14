using Grand.Business.Core.Interfaces.Catalog.Brands;
using Grand.Business.Core.Interfaces.Catalog.Categories;
using Grand.Business.Core.Interfaces.Catalog.Collections;
using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Business.Core.Utilities.Catalog;
using Grand.Domain.Blogs;
using Grand.Domain.Catalog;

namespace Widgets.Slider.Services;

public class LinkSelectorService : ILinkSelectorService
{
    private readonly ICategoryService _categoryService;
    private readonly IProductService _productService;
    private readonly IBrandService _brandService;
    private readonly ICollectionService _collectionService;
    private readonly IBlogService _blogService;

    public LinkSelectorService(
        ICategoryService categoryService,
        IProductService productService,
        IBrandService brandService,
        ICollectionService collectionService,
        IBlogService blogService)
    {
        _categoryService = categoryService;
        _productService = productService;
        _brandService = brandService;
        _collectionService = collectionService;
        _blogService = blogService;
    }

    public async Task<(IList<Category> Categories, int TotalCount)> GetCategories(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="")
    {
        var categories = await _categoryService.GetAllCategories(storeId: storeId, pageIndex: pageIndex, pageSize: pageSize,categoryName:name);
        return (categories, categories.TotalCount);
    }

    public async Task<(IList<Product> Products, int TotalCount)> GetProducts(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="")
    {
        var products = await _productService.SearchProducts(
            storeId: storeId,
            pageIndex: pageIndex,
            pageSize: pageSize,
            keywords:string.IsNullOrEmpty(name)? null : name
        );
        return (products.products, products.products.TotalCount);
    }

    public async Task<(IList<Brand> Brands, int TotalCount)> GetBrands(string storeId, int pageIndex = 0, int pageSize = int.MaxValue, string name="")
    {
        var brands = await _brandService.GetAllBrands(storeId: storeId, pageIndex: pageIndex, pageSize: pageSize,brandName:name);
        return (brands, brands.TotalCount);
    }

    public async Task<(IList<Collection> Collections, int TotalCount)> GetCollections(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="")
    {
        var collections = await _collectionService.GetAllCollections(storeId: storeId, pageIndex: pageIndex, pageSize: pageSize,collectionName:name,showHidden:true);
        return (collections, collections.TotalCount);
    }

    public async Task<(IList<BlogPost> BlogPosts, int TotalCount)> GetBlogPosts(string storeId, int pageIndex = 0, int pageSize = int.MaxValue,string name="")
    {
        var blogPosts = await _blogService.GetAllBlogPosts(storeId: storeId, pageIndex: pageIndex, pageSize: pageSize,blogPostName:name);
        return (blogPosts, blogPosts.TotalCount);
    }
}