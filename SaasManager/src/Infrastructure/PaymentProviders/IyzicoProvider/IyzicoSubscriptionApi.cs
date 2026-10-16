using Iyzipay;
using Iyzipay.Model;
using Iyzipay.Model.V2;
using Iyzipay.Model.V2.Subscription;
using Iyzipay.Request;
using Iyzipay.Request.V2.Subscription;

namespace SaasManager.Infrastructure.PaymentProviders.IyzicoProvider;

// Keep the provider's real SDK boundary injectable; tests never replace payment decisions or contact a merchant account.
public interface IIyzicoSubscriptionApi
{
    ResponseData<PlanResource> ReadPlan(RetrievePlanRequest request, Options options);
    ResponseData<SubscriptionCreatedResource> Initialize(SubscriptionInitializeRequest request, Options options);
    IyzipayResourceV2 Activate(ActivateSubscriptionRequest request, Options options);
    ResponseData<SubscriptionResource> ReadSubscription(RetrieveSubscriptionRequest request, Options options);
    Task<BinNumber> ReadBinAsync(RetrieveBinNumberRequest request, Options options);
}

internal sealed class IyzicoSubscriptionApi : IIyzicoSubscriptionApi
{
    public ResponseData<PlanResource> ReadPlan(RetrievePlanRequest request, Options options) => Plan.Retrieve(request, options);
    public ResponseData<SubscriptionCreatedResource> Initialize(SubscriptionInitializeRequest request, Options options) => Subscription.Initialize(request, options);
    public IyzipayResourceV2 Activate(ActivateSubscriptionRequest request, Options options) => Subscription.Activate(request, options);
    public ResponseData<SubscriptionResource> ReadSubscription(RetrieveSubscriptionRequest request, Options options) => Subscription.Retrieve(request, options);
    public Task<BinNumber> ReadBinAsync(RetrieveBinNumberRequest request, Options options) => BinNumber.Retrieve(request, options);
}
