using Grand.Business.Core.Interfaces.Catalog.Products;
using Grand.Business.Core.Interfaces.Cms;
using Grand.Web.Common.Controllers;
using Grand.Business.Core.Interfaces.Common.Security;
using Grand.Business.Core.Interfaces.System.Reports;
using Grand.Business.Core.Queries.Catalog;
using Grand.Domain.Blogs;
using Grand.Domain.Catalog;
using Grand.Domain.Customers;
using Grand.Domain.Knowledgebase;
using Grand.Domain.News;
using Grand.Domain.Orders;
using Grand.Domain.Payments;
using Grand.Infrastructure;
using Grand.Infrastructure.Caching;
using Grand.Web.Events.Cache;
using Grand.Web.Features.Models.Blogs;
using Grand.Web.Features.Models.Catalog;
using Grand.Web.Features.Models.News;
using Grand.Web.Features.Models.Products;
using Grand.Web.Models.Catalog;
using JetBrains.Annotations;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace Grand.Web.Controllers
{
    public class ComponentController : BasePublicController
    {
        private readonly IMediator _mediator;
        private readonly IWorkContext _workContext;
        private readonly CatalogSettings _catalogSettings;
        private readonly BlogSettings _blogSettings;
        private readonly KnowledgebaseSettings _knowledgebaseSettings;
        private readonly IProductService _productService;
        private readonly ICacheBase _cacheBase;
        private readonly IOrderReportService _orderReportService;
        private readonly NewsSettings _newsSettings;
        private readonly IKnowledgebaseService _knowledgebaseService;
        private readonly IRecentlyViewedProductsService _recentlyViewedProductsService;
        private readonly ShoppingCartSettings _shoppingCartSettings;
        private readonly IPermissionService _permissionService;

        public ComponentController(
            IMediator mediator,
            IWorkContext workContext,
            CatalogSettings catalogSettings,
            BlogSettings blogSettings,
            KnowledgebaseSettings knowledgebaseSettings,
            IProductService productService,
            ICacheBase cacheBase,
            IOrderReportService orderReportService,
            NewsSettings newsSettings,
            IKnowledgebaseService knowledgebaseService,
            IRecentlyViewedProductsService recentlyViewedProductsService,
            ShoppingCartSettings shoppingCartSettings,
            IPermissionService permissionService)
        {
            _mediator = mediator;
            _workContext = workContext;
            _catalogSettings = catalogSettings;
            _blogSettings = blogSettings;
            _knowledgebaseSettings = knowledgebaseSettings;
            _productService = productService;
            _cacheBase = cacheBase;
            _orderReportService = orderReportService;
            _newsSettings = newsSettings;
            _knowledgebaseService = knowledgebaseService;
            _recentlyViewedProductsService = recentlyViewedProductsService;
            _shoppingCartSettings = shoppingCartSettings;
            _permissionService = permissionService;
        }

        [HttpGet]
        public async Task<IActionResult> Index(string name)
        {
            if (string.IsNullOrEmpty(name))
                return BadRequest("Component name is required");

            try
            {
                // ViewComponent'i dinamik olarak render et
                return ViewComponent(name);
            }
            catch
            {
                return NotFound($"Component '{name}' not found");
            }
        }

        [HttpPost]
        public async Task<IActionResult> Index(string name,
            [FromBody] [ItemCanBeNull] IDictionary<string, object> arguments)
        {
            if (string.IsNullOrEmpty(name))
                return BadRequest("Component name is required");

            try
            {
                // arguments null ise boş bir dictionary oluştur
                var args = arguments ?? new Dictionary<string, object>();

                // JsonElement'den uygun tipe dönüşüm yap
                var convertedArgs = new Dictionary<string, object>();
                foreach (var arg in args)
                {
                    if (arg.Value is JsonElement jsonElement)
                    {
                        switch (jsonElement.ValueKind)
                        {
                            case JsonValueKind.Number:
                                // Int veya nullable int için dönüşüm
                                if (arg.Key.EndsWith("Size", StringComparison.OrdinalIgnoreCase))
                                {
                                    convertedArgs[arg.Key] = jsonElement.GetInt32();
                                }
                                else
                                {
                                    convertedArgs[arg.Key] = jsonElement.GetDecimal();
                                }

                                break;
                            case JsonValueKind.String:
                                convertedArgs[arg.Key] = jsonElement.GetString();
                                break;
                            case JsonValueKind.True:
                            case JsonValueKind.False:
                                convertedArgs[arg.Key] = jsonElement.GetBoolean();
                                break;
                            case JsonValueKind.Null:
                                convertedArgs[arg.Key] = null;
                                break;
                            default:
                                convertedArgs[arg.Key] = arg.Value;
                                break;
                        }
                    }
                    else
                    {
                        convertedArgs[arg.Key] = arg.Value;
                    }
                }

                // ViewComponent'i parametrelerle birlikte çağır
                return ViewComponent(name, convertedArgs);
            }
            catch
            {
                return NotFound($"Component '{name}' not found or invalid parameters");
            }
        }


        [HttpGet]
        public async Task<IActionResult> HomePageCategories()
        {
            var model = await _mediator.Send(new GetHomepageCategory {
                Customer = _workContext.CurrentCustomer,
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> CategoryFeaturedProducts()
        {
            var model = await _mediator.Send(new GetCategoryFeaturedProducts {
                Customer = _workContext.CurrentCustomer,
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> PersonalizedProducts(int? productThumbPictureSize)
        {
            if (!_catalogSettings.PersonalizedProductsEnabled || _catalogSettings.PersonalizedProductsNumber == 0)
                return Json(new List<ProductOverviewModel>());

            var products = await _mediator.Send(new GetPersonalizedProductsQuery {
                CustomerId = _workContext.CurrentCustomer.Id,
                ProductsNumber = _catalogSettings.PersonalizedProductsNumber
            });

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> CustomerRecommendedProducts(int? productThumbPictureSize)
        {
            if (!_catalogSettings.RecommendedProductsEnabled)
                return Json(new List<ProductOverviewModel>());

            var products = await _mediator.Send(new GetRecommendedProductsQuery {
                CustomerGroupIds = _workContext.CurrentCustomer.GetCustomerGroupIds(),
                StoreId = _workContext.CurrentStore.Id
            });

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> RecommendedProducts(string productId, int? productThumbPictureSize)
        {
            var productIds = (await _productService.GetProductById(productId)).RecommendedProduct.ToArray();
            if (!productIds.Any())
                return Json(new List<ProductOverviewModel>());

            var products = await _productService.GetProductsByIds(productIds);

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> SuggestedProducts(int? productThumbPictureSize)
        {
            if (!_catalogSettings.SuggestedProductsEnabled || _catalogSettings.SuggestedProductsNumber == 0)
                return Json(new List<ProductOverviewModel>());

            var products = await _mediator.Send(new GetSuggestedProductsQuery {
                CustomerTagIds = _workContext.CurrentCustomer.CustomerTags.ToArray(),
                ProductsNumber = _catalogSettings.SuggestedProductsNumber
            });

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }
        
        [HttpGet]
        public async Task<IActionResult> HomePageProducts(int? productThumbPictureSize)
        {
            var productsIds = await _cacheBase.GetAsync(CacheKeyConst.HOMEPAGE_PRODUCTS_MODEL_KEY,
                async () => await _productService.GetAllProductsDisplayedOnHomePage());

            var products = await _productService.GetProductsByIds(productsIds.ToArray());

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> BlogCategories()
        {
            if (!_blogSettings.Enabled)
                return Json(null);

            var model = await _mediator.Send(new GetBlogPostCategory());
            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> BlogMonths()
        {
            if (!_blogSettings.Enabled)
                return Json(null);

            var model = await _mediator.Send(new GetBlogPostYear());
            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> BlogTags()
        {
            if (!_blogSettings.Enabled)
                return Json(null);

            var model = await _mediator.Send(new GetBlogPostTagList());
            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> CategoryNavigation(string currentCategoryId = "", string currentProductId = "")
        {
            var model = await _mediator.Send(new GetCategoryNavigation() {
                Customer = _workContext.CurrentCustomer,
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore,
                CurrentCategoryId = currentCategoryId,
                CurrentProductId = currentProductId
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> CollectionFeaturedProducts()
        {
            var model = await _mediator.Send(new GetCollectionFeaturedProducts {
                Customer = _workContext.CurrentCustomer,
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> CollectionNavigation()
        {
            var model = await _mediator.Send(new GetCollectionNavigation {
                Customer = _workContext.CurrentCustomer,
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> HomePageBestSellers(int? productThumbPictureSize)
        {
            if (!_catalogSettings.ShowBestsellersOnHomepage || _catalogSettings.NumberOfBestsellersOnHomepage == 0)
                return Json(new List<ProductOverviewModel>());

            var productIds = new List<string>();

            //load and cache report
            if (_catalogSettings.BestsellersFromReports)
            {
                var fromdate = DateTime.UtcNow.AddMonths(_catalogSettings.PeriodBestsellers > 0
                    ? -_catalogSettings.PeriodBestsellers
                    : -12);
                var report = await _cacheBase.GetAsync(
                    string.Format(CacheKeyConst.HOMEPAGE_BESTSELLERS_IDS_KEY, _workContext.CurrentStore.Id), async () =>
                        await _orderReportService.BestSellersReport(
                            createdFromUtc: fromdate,
                            ps: PaymentStatus.Paid,
                            storeId: _workContext.CurrentStore.Id,
                            pageSize: _catalogSettings.NumberOfBestsellersOnHomepage));

                productIds = report.Select(x => x.ProductId).ToList();
            }
            else
            {
                productIds = await _cacheBase.GetAsync(CacheKeyConst.BESTSELLER_PRODUCTS_MODEL_KEY,
                    async () => (await _productService.GetAllProductsDisplayedOnBestSeller()).ToList());
            }

            //load products
            var products = await _productService.GetProductsByIds(productIds.ToArray());

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products.Take(_catalogSettings.NumberOfBestsellersOnHomepage)
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> HomePageBlog()
        {
            if (!_blogSettings.Enabled || !_blogSettings.ShowBlogOnHomePage)
                return Json(null);

            var model = await _mediator.Send(new GetHomePageBlog() {
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> HomePageBrands()
        {
            var model = await _mediator.Send(new GetHomepageBrands {
                Customer = _workContext.CurrentCustomer,
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore
            });
            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> HomePageCollections()
        {
            var model = await _mediator.Send(new GetHomepageCollections {
                Customer = _workContext.CurrentCustomer,
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore
            });
            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> HomePageNewProducts(int? productThumbPictureSize)
        {
            if (!_catalogSettings.NewProductsOnHomePage)
                return Json(new List<ProductOverviewModel>());

            var products = (await _mediator.Send(new GetSearchProductsQuery {
                Customer = _workContext.CurrentCustomer,
                StoreId = _workContext.CurrentStore.Id,
                VisibleIndividuallyOnly = true,
                MarkedAsNewOnly = true,
                OrderBy = ProductSortingEnum.CreatedOn,
                PageSize = _catalogSettings.NewProductsNumberOnHomePage
            })).products;

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });
            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> HomePageNews()
        {
            if (!_newsSettings.Enabled || !_newsSettings.ShowNewsOnMainPage)
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetHomePageNewsItems());
            return !model.NewsItems.Any() ? Json(new List<ProductOverviewModel>()) : Json(model);
        }


        [HttpGet]
        public async Task<IActionResult> PopularProductTags()
        {
            var model = await _mediator.Send(new GetPopularProductTags {
                Language = _workContext.WorkingLanguage,
                Store = _workContext.CurrentStore
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> ProductsAlsoPurchased(string productId, int? productThumbPictureSize)
        {
            if (!_catalogSettings.ProductsAlsoPurchasedEnabled)
                return Json(new List<ProductOverviewModel>());

            //load and cache report
            var productIds = await _cacheBase.GetAsync(
                string.Format(CacheKeyConst.PRODUCTS_ALSO_PURCHASED_IDS_KEY, productId, _workContext.CurrentStore.Id),
                () =>
                    _orderReportService
                        .GetAlsoPurchasedProductsIds(_workContext.CurrentStore.Id, productId,
                            _catalogSettings.ProductsAlsoPurchasedNumber)
            );

            //load products
            var products = await _productService.GetProductsByIds(productIds);

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            //prepare model
            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> RecentlyViewedProductsBlock(int? productThumbPictureSize, bool? preparePriceModel)
        {
            if (!_catalogSettings.RecentlyViewedProductsEnabled)
                return Json(new List<ProductOverviewModel>());

            var preparePictureModel = productThumbPictureSize.HasValue;
            var products = await _recentlyViewedProductsService.GetRecentlyViewedProducts(_workContext.CurrentCustomer.Id,
                _catalogSettings.RecentlyViewedProductsNumber);

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = preparePictureModel,
                PreparePriceModel = preparePriceModel.GetValueOrDefault(),
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> RelatedProducts(string productId, int? productThumbPictureSize)
        {
            var productIds = (await _productService.GetProductById(productId)).RelatedProducts.OrderBy(x => x.DisplayOrder)
                .Select(x => x.ProductId2).ToArray();

            //load products
            var products = await _productService.GetProductsByIds(productIds);

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> SimilarProducts(string productId, int? productThumbPictureSize)
        {
            var productIds = (await _productService.GetProductById(productId)).SimilarProducts.OrderBy(x => x.DisplayOrder)
                .Select(x => x.ProductId2).ToArray();
            if (!productIds.Any())
                return Json(new List<ProductOverviewModel>());

            var products = await _productService.GetProductsByIds(productIds);

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PreparePictureModel = true,
                PreparePriceModel = true,
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> CrossSellProducts(int? productThumbPictureSize)
        {
            if (_shoppingCartSettings.CrossSellsNumber == 0)
                return Json(new List<ProductOverviewModel>());

            var cart = _workContext.CurrentCustomer.ShoppingCartItems
                .Where(sci => sci.ShoppingCartTypeId == ShoppingCartType.ShoppingCart)
                .LimitPerStore(_shoppingCartSettings.SharedCartBetweenStores, _workContext.CurrentStore.Id)
                .ToList();

            var products =
                await _productService.GetCrossSellProductsByShoppingCart(cart, _shoppingCartSettings.CrossSellsNumber);

            if (!products.Any())
                return Json(new List<ProductOverviewModel>());

            var model = await _mediator.Send(new GetProductOverview {
                PrepareSpecificationAttributes = _catalogSettings.ShowSpecAttributeOnCatalogPages,
                ProductThumbPictureSize = productThumbPictureSize,
                Products = products,
                ForceRedirectionAfterAddingToCart = true
            });

            return Json(model);
        }

        [HttpGet]
        public async Task<IActionResult> VendorNavigation()
        {
            var model = await _mediator.Send(new GetVendorNavigation());
            return Json(model);
        }
    }
}