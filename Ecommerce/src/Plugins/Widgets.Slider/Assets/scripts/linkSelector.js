// Link Selector Tool for Slider
var SliderLinkSelector = {
    init: function (settings) {
        this.linkTypeSelector = $(settings.linkTypeSelector);
        this.manualLinkPanel = $(settings.manualLinkPanel);
        this.categorySelector = $(settings.categorySelector);
        this.productSelector = $(settings.productSelector);
        this.brandSelector = $(settings.brandSelector);
        this.collectionSelector = $(settings.collectionSelector);
        this.blogPostSelector = $(settings.blogPostSelector);
        this.searchTermInput = $(settings.searchTermInput);
        this.referenceIdInput = $(settings.referenceIdInput);
        this.referenceParamsInput = $(settings.referenceParamsInput);

        // URL paths for AJAX
        this.endpoints = {
            categories: '/Admin/WidgetsSlider/LinkSelector/GetCategories',
            products: '/Admin/WidgetsSlider/LinkSelector/GetProducts',
            brands: '/Admin/WidgetsSlider/LinkSelector/GetBrands',
            collections: '/Admin/WidgetsSlider/LinkSelector/GetCollections',
            blogPosts: '/Admin/WidgetsSlider/LinkSelector/GetBlogPosts'
        };

        this.setupEventHandlers();
        this.setupSelectWidgets();
        this.togglePanels(); // Initial toggle
    },

    setupEventHandlers: function() {
        var self = this;

        // Link type change event
        this.linkTypeSelector.change(function() {
            self.togglePanels();
        });

        // Reference selectors change events
        this.categorySelector.change(function() {
            self.updateReferenceId($(this).val());
        });

        this.productSelector.change(function() {
            self.updateReferenceId($(this).val());
        });

        this.brandSelector.change(function() {
            self.updateReferenceId($(this).val());
        });

        this.collectionSelector.change(function() {
            self.updateReferenceId($(this).val());
        });

        this.blogPostSelector.change(function() {
            self.updateReferenceId($(this).val());
        });

        // Search term change
        this.searchTermInput.on('input', function() {
            self.updateSearchParameters($(this).val());
        });
    },

    setupSelectWidgets: function() {
        var self = this;

        // Setup Kendo DropDownList for Product selector
        if (this.productSelector.length > 0) {
            var productDropDownList = this.productSelector.data("kendoDropDownList");
            if(productDropDownList != null){
                productDropDownList.destroy();
            }
            this.productSelector.kendoDropDownList({
                autobind: false,
                optionLabel: "Ürün Seçiniz...",
                filter: "startswith",
                dataSource: {
                    dataType:"json",
                    contentType: "application/json",
                    transport: {
                        read: {
                            url: this.endpoints.products,
                            type: "POST"
                        },
                        parameterMap: function(data, type){
                            var filter = undefined;
                            if(data.filter && data.filter.filters && data.filter.filters.length > 0) {
                                filter = data.filter['filters'][0].value;
                            }
                            return {
                                command:{
                                    Page: data.page,
                                    PageSize: data.pageSize,
                                },
                                q:filter,
                            };
                        },
                    },
                    schema: {
                        data: "Data",
                        total: "Total"
                    },

                    serverFiltering: true,
                    serverPaging: true,
                    pageSize: 50
                },


                // filtering: function(e) {
                //     var filter = e.filter;
                //     var filterInput = dropdownlist.filterInput;
                //     e.preventDefault();
                // },
                dataTextField: "Name",
                dataValueField: "Id",
            });
        }

        // Setup Kendo DropDownList for Category selector
        if (this.categorySelector.length > 0) {
            var categoryDropDownList = this.categorySelector.data("kendoDropDownList");
            if(categoryDropDownList != null){
                categoryDropDownList.destroy();
            }
            this.categorySelector.kendoDropDownList({
                autobind: false,
                optionLabel: "Select category...",
                filter: "startswith",
                dataSource: {
                    dataType:"json",
                    contentType: "application/json",
                    transport: {
                        read: {
                            url: this.endpoints.categories,
                            type: "POST"
                        },
                        parameterMap: function(data, type){
                            var filter = undefined;
                            if(data.filter && data.filter.filters && data.filter.filters.length > 0) {
                                filter = data.filter['filters'][0].value;
                            }
                            return {
                                command:{
                                    Page: data.page,
                                    PageSize: data.pageSize,
                                },
                                q:filter,
                            };
                        },
                    },
                    schema: {
                        data: "Data",
                        total: "Total"
                    },

                    serverFiltering: true,
                    serverPaging: true,
                    pageSize: 50
                },
                dataTextField: "Name",
                dataValueField: "Id",
            });
        }

        // Setup Kendo DropDownList for Brand selector
        if (this.brandSelector.length > 0) {
            var brandDropDownList = this.brandSelector.data("kendoDropDownList");
            if(brandDropDownList != null){
                brandDropDownList.destroy();
            }
            this.brandSelector.kendoDropDownList({
                autobind: false,
                optionLabel: "Select brand...",
                filter: "startswith",
                dataSource: {
                    dataType:"json",
                    contentType: "application/json",
                    transport: {
                        read: {
                            url: this.endpoints.brands,
                            type: "POST"
                        },
                        parameterMap: function(data, type){
                            var filter = undefined;
                            if(data.filter && data.filter.filters && data.filter.filters.length > 0) {
                                filter = data.filter['filters'][0].value;
                            }
                            return {
                                command:{
                                    Page: data.page,
                                    PageSize: data.pageSize,
                                },
                                q:filter,
                            };
                        },
                    },
                    schema: {
                        data: "Data",
                        total: "Total"
                    },

                    serverFiltering: true,
                    serverPaging: true,
                    pageSize: 50
                },
                dataTextField: "Name",
                dataValueField: "Id",
            });
        }

        // Setup Kendo DropDownList for Collection selector
        if (this.collectionSelector.length > 0) {
            var collectionDropDownList =this.collectionSelector.data("kendoDropDownList");
            if(collectionDropDownList != null){
                collectionDropDownList.destroy();
            }
            this.collectionSelector.kendoDropDownList({
                autobind: false,
                optionLabel: "Select collection...",
                filter: "startswith",
                dataSource: {
                    dataType:"json",
                    contentType: "application/json",
                    transport: {
                        read: {
                            url: this.endpoints.collections,
                            type: "POST"
                        },
                        parameterMap: function(data, type){
                            var filter = undefined;
                            if(data.filter && data.filter.filters && data.filter.filters.length > 0) {
                                filter = data.filter['filters'][0].value;
                            }
                            return {
                                command:{
                                    Page: data.page,
                                    PageSize: data.pageSize,
                                },
                                q:filter,
                            };
                        },
                    },
                    schema: {
                        data: "Data",
                        total: "Total"
                    },

                    serverFiltering: true,
                    serverPaging: true,
                    pageSize: 50
                },
                dataTextField: "Name",
                dataValueField: "Id",
            });
        }

        // Setup Kendo DropDownList for Blog Post selector
        if (this.blogPostSelector.length > 0) {
            this.blogPostSelector.kendoDropDownList({
                autobind: false,
                optionLabel: "Select blog post...",
                filter: "startswith",
                dataSource: {
                    dataType:"json",
                    contentType: "application/json",
                    transport: {
                        read: {
                            url: this.endpoints.blogPosts,
                            type: "POST"
                        },
                        parameterMap: function(data, type){
                            var filter = undefined;
                            if(data.filter && data.filter.filters && data.filter.filters.length > 0) {
                                filter = data.filter['filters'][0].value;
                            }
                            return {
                                command:{
                                    Page: data.page,
                                    PageSize: data.pageSize,
                                },
                                q:filter,
                            };
                        },
                    },
                    schema: {
                        data: "Data",
                        total: "Total"
                    },

                    serverFiltering: true,
                    serverPaging: true,
                    pageSize: 50
                },
                dataTextField: "Name",
                dataValueField: "Id",
            });
        }
    },

    formatProductItem: function (item) {
        if (item.loading) return item.text;
        return $('<div class="select2-result-product">' + item.text + '</div>');
    },

    formatProductSelection: function (item) {
        return item.text;
    },

    formatCategoryItem: function (item) {
        if (item.loading) return item.text;
        var markup = '<div class="select2-result-category">';
        if (item.breadcrumb) {
            markup += '<small class="text-muted">' + item.breadcrumb + ' > </small>';
        }
        markup += item.text + '</div>';
        return markup;
    },

    formatCategorySelection: function (item) {
        return item.text;
    },

    togglePanels: function() {
        // Hide all panels first
        this.manualLinkPanel.hide();
        this.categorySelector.closest('.form-group').hide();
        this.productSelector.closest('.form-group').hide();
        this.brandSelector.closest('.form-group').hide();
        this.collectionSelector.closest('.form-group').hide();
        this.blogPostSelector.closest('.form-group').hide();
        this.searchTermInput.closest('.form-group').hide();

        // Show panel based on link type
        var linkType = parseInt(this.linkTypeSelector.val());

        switch(linkType) {
            case 0: // Manual
                this.manualLinkPanel.show();
                break;

            case 1: // Category
                this.categorySelector.closest('.form-group').show();
                this.updateReferenceId(this.categorySelector.val());
                break;

            case 2: // Product
                this.productSelector.closest('.form-group').show();
                this.updateReferenceId(this.productSelector.val());
                break;

            case 3: // Brand
                this.brandSelector.closest('.form-group').show();
                this.updateReferenceId(this.brandSelector.val());
                break;

            case 4: // Collection
                this.collectionSelector.closest('.form-group').show();
                this.updateReferenceId(this.collectionSelector.val());
                break;

            case 5: // Blog
                this.blogPostSelector.closest('.form-group').show();
                this.updateReferenceId(this.blogPostSelector.val());
                break;

            case 6: // BlogList
                // Nothing to show for BlogList as it's a fixed URL
                this.updateReferenceId('');
                break;

            case 7: // Search
                this.searchTermInput.closest('.form-group').show();
                this.updateSearchParameters(this.searchTermInput.val());
                break;
        }
    },

    updateReferenceId: function(value) {
        this.referenceIdInput.val(value || '');
    },

    updateSearchParameters: function(searchTerm) {
        if (searchTerm) {
            var searchParams = {
                "q": searchTerm
            };

            this.referenceParamsInput.val(JSON.stringify(searchParams));
        } else {
            this.referenceParamsInput.val('');
        }
    }
};