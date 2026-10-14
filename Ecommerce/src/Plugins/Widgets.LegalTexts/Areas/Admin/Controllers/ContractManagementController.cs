using Grand.Business.Core.Extensions;
using Grand.Business.Core.Interfaces.Common.Localization;
using Grand.Business.Core.Utilities.Common.Security;
using Grand.Business.Core.Utilities.Messages.DotLiquidDrops;
using Grand.Web.Common.Controllers;
using Grand.Web.Common.DataSource;
using Grand.Web.Common.Filters;
using Grand.Web.Common.Security.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Widgets.LegalTexts.Models;
using Widgets.LegalTexts.Services;



namespace Widgets.LegalTexts.Areas.Admin.Controllers
{
    [AuthorizeAdmin]
    [Area("Admin")]
    [PermissionAuthorize(PermissionSystemName.CheckoutAttributes)]
    public class ContractManagementController : BasePluginController
    {
        private readonly ILegalTextMessageTemplateService _messageTemplateService;
        private readonly ILanguageService _languageService;
        private readonly ITranslationService _translationService;

        public ContractManagementController(
            ILegalTextMessageTemplateService messageTemplateService,
            ILanguageService languageService,
            ITranslationService translationService)
        {
            _messageTemplateService = messageTemplateService;
            _languageService = languageService;
            _translationService = translationService;
        }

        public IActionResult Index()
        {
            return RedirectToAction("List");
        }

        public IActionResult List()
        {
            var model = new LegalTextMessageTemplateListModel();
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderConfirmation"), Value = "OrderConfirmation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderCancellation"), Value = "OrderCancellation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.ReturnRequest"), Value = "ReturnRequest" });

            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> List(DataSourceRequest command, LegalTextMessageTemplateListModel model)
        {
            var templates = await _messageTemplateService.GetAllMessageTemplates(model, command.Page - 1, command.PageSize);

            var gridModel = new DataSourceResult {
                Data = templates.Select(x => x.ToModel()),
                Total = templates.TotalCount
            };

            return Json(gridModel);
        }

        public async Task<IActionResult> Create()
        {
            var model = new LegalTextMessageTemplateModel();
            model.AllowedTokens= LiquidExtensions.GetTokens(
                typeof(LiquidCustomer),
                typeof(LiquidStore),
                typeof(LiquidShoppingCart),
                typeof(LiquidShippingAdress),
                typeof(LiquidBillingAdress),
                typeof(LiquidOrderTotals),
                typeof(LiquidShoppingCartItem)
            );

            model.AllowedTokens.Add("{{ShoppingCartItem.UnitPrice}}");
            model.AllowedTokens.Add("{{ShoppingCartItem.SubTotal}}");

            //locales
            await AddLocales(_languageService, model.Locales);

            //categories
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderConfirmation"), Value = "OrderConfirmation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderCancellation"), Value = "OrderCancellation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.ReturnRequest"), Value = "ReturnRequest" });

            return View(model);
        }

        [HttpPost, ArgumentNameFilter(KeyName = "save-continue", Argument = "continueEditing")]
        public async Task<IActionResult> Create(LegalTextMessageTemplateModel model, bool continueEditing)
        {
            if (ModelState.IsValid)
            {
                var template = model.ToEntity();
                await _messageTemplateService.InsertMessageTemplate(template);

                Success(_translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Template.Added"));
                return continueEditing ? RedirectToAction("Edit", new { id = template.Id }) : RedirectToAction("List");
            }

            //categories
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderConfirmation"), Value = "OrderConfirmation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderCancellation"), Value = "OrderCancellation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.ReturnRequest"), Value = "ReturnRequest" });

            return View(model);
        }

        public async Task<IActionResult> Edit(string id)
        {
            var template = await _messageTemplateService.GetMessageTemplateById(id);
            if (template == null)
                return RedirectToAction("List");

            var model = template.ToModel();
            //locales
            await AddLocales(_languageService, model.Locales, (locale, languageId) =>
            {
                locale.Name = template.GetTranslation(x => x.Name, languageId, false);
                locale.Body = template.GetTranslation(x => x.Body, languageId, false);
            });

            model.AllowedTokens= LiquidExtensions.GetTokens(
                typeof(LiquidCustomer),
                typeof(LiquidStore),
                typeof(LiquidShoppingCart),
                typeof(LiquidShippingAdress),
                typeof(LiquidBillingAdress),
                typeof(LiquidOrderTotals),
                typeof(LiquidShoppingCartItem)
            );

            model.AllowedTokens.Add("{{ShoppingCartItem.UnitPrice}}");
            model.AllowedTokens.Add("{{ShoppingCartItem.SubTotal}}");

            //categories
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderConfirmation"), Value = "OrderConfirmation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderCancellation"), Value = "OrderCancellation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.ReturnRequest"), Value = "ReturnRequest" });

            return View(model);
        }

        [HttpPost, ArgumentNameFilter(KeyName = "save-continue", Argument = "continueEditing")]
        public async Task<IActionResult> Edit(LegalTextMessageTemplateModel model, bool continueEditing)
        {
            var template = await _messageTemplateService.GetMessageTemplateById(model.Id);
            if (template == null)
                return RedirectToAction("List");

            if (ModelState.IsValid)
            {
                template = model.ToEntity(template);
                await _messageTemplateService.UpdateMessageTemplate(template);

                Success(_translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Messages.Template.Updated"));
                return continueEditing ? RedirectToAction("Edit", new { id = template.Id }) : RedirectToAction("List");
            }

            //categories
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderConfirmation"), Value = "OrderConfirmation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.OrderCancellation"), Value = "OrderCancellation" });
            model.AvailableCategories.Add(new SelectListItem { Text = _translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Fields.Categories.ReturnRequest"), Value = "ReturnRequest" });

            return View(model);
        }

        [HttpGet]
        public async Task<IActionResult> Delete(string id)
        {
            var template = await _messageTemplateService.GetMessageTemplateById(id);
            if (template == null)
                return RedirectToAction("List");

            await _messageTemplateService.DeleteMessageTemplate(template);

            Success(_translationService.GetResource("LegalTexts.Plugin.LegalTextMessageTemplate.Messages.Template.Deleted"));
            return RedirectToAction("List");
        }

        [HttpPost]
        public async Task<IActionResult> ValidateTemplate(string template)
        {
            try
            {
                var liquidTemplate = DotLiquid.Template.Parse(template);
                return Json(new { Valid = true });
            }
            catch (Exception ex)
            {
                return Json(new { Valid = false, Message = ex.Message });
            }
        }
    }
}
