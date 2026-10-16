# SaaS subscription activation

The default local demo and Linux deployment use the explicit zero-amount trial path. They do not require a payment account or submit cards. Paid registration is a separate opt-in merchant configuration; successful trial/cloud-free CI is not evidence of a real payment.

## Provisioning entitlement

The direct store-registration handler and owner retry action check the persisted business/subscription before creating tenant secrets or queue work. The business must belong to the current registration owner and match its converted business ID. The subscription and plan must be active, not deleted and not expired. A free trial must also be zero amount, within its trial/start dates, public and selected by the configured Portable trial policy or explicit Local self-service profile. Paid setup instead needs the owner's completed server payment-setup state with a provider reference. Merely selecting a plan or creating a business is insufficient. Owners can still read their job status after a subscription becomes unavailable; they cannot start another resource-creation attempt through retry.

The new entitlement guard does not rewrite legacy subscriptions or infer approval from a business status, browser field, client token or success page. Previously inconsistent `AwaitingPayment` records require explicit merchant reconciliation. It is not a recurring-billing webhook processor or a suspension/deletion policy for already published stores.

## Configure an actual iyzico merchant

Prepare a monthly recurring TRY pricing plan in the intended iyzico merchant account. Keep its reference, amount and trial days consistent with the selected SaaS plan. Checkout reads the remote plan and rejects mismatched identity, currency, amount, interval, trial or inactive status. It does not create merchant products/pricing plans during a customer's request or invent a placeholder reference. The existing `SubscriptionPlan.Code` is the merchant pricing-plan reference; a sample value such as `STARTER_TRIAL` cannot be used for paid registration.

Standalone SaaS hosts use this private settings shape:

```json
{
  "Payments": {
    "Provider": "Iyzico",
    "Iyzico": {
      "IsSandbox": true,
      "ApiKey": "YOUR_PRIVATE_MERCHANT_API_KEY",
      "SecretKey": "YOUR_PRIVATE_MERCHANT_SECRET"
    }
  },
  "CardProtection": { "Provider": "Platform" }
}
```

Keep this file outside Git with owner-only permissions, or supply its corresponding `Payments__*` environment variables. Select the shared AesGcm or optional Azure card protector using the existing [SaaS provider configuration](SAAS_PROVIDERS.md). Explicit `Payments:Provider=Disabled` disables merchant credentials even if old values remain in the input. Development alone can still read legacy `Dev:Iyzico` credentials when no explicit provider was selected; Production/Staging never fall back to them. Sandbox selects the real sandbox API and requires its actual account/response; it is not a simulated successful payment.

For Linux Compose, merge only the nested `Providers:Payments` object from [payments.example.json](../infra/production/payments.example.json) into the private deployment input. Fill its merchant keys, choose `IsSandbox` explicitly, and intentionally select `Provider=Iyzico`. Before the first deployment, set the existing `TrialPlan.Code` to the actual merchant pricing-plan UUID and its `Price`/`TrialDays` to that plan's terms. This plan remains available for the dedicated configured free trial too; free trial enrollments record zero amount and do not call iyzico. Existing deployments must reconcile their original seeded plan explicitly rather than silently replacing billing targets.

The generator requires nonempty keys and a real pricing reference before enabling this profile. It mounts the merchant settings only through SaaS's private 0600 configuration and enables its shared card protector. Worker, installer, commerce, admin, gateway, bootstrap and Compose environment definitions receive no merchant key. The private operator deployment input also contains these settings; include it in the protected backup. New payment-provider database records contain metadata only, with no copy of the runtime API key/secret or credential-bearing configuration. Existing legacy database credential copies are preserved and require a separately reviewed cleanup/rotation.

## Activation and retry evidence

Both sandbox and live modes follow the same SDK flow: read/check the merchant plan, create a real `PENDING` subscription with the correct card expiry year, then activate the same subscription/customer/plan and confirm `ACTIVE` through a provider read. Provider rejection, invalid/missing references, unexpected resources and transport errors cannot become a successful payment. Only confirmed activation changes the local subscription to `Active`, completes payment setup and invokes the ordinary durable tenant provisioning handler.

An active subscription with trial days may only have completed card authorization; it is not proof of a captured full subscription charge. See iyzico's [subscription behavior](https://docs.iyzico.com/en/products/subscription/subscription-implementation/subscription-transactions). A completed local payment-setup replay reconciles its original provisioning request without initializing another provider subscription. Replaying activation for an already active provider resource verifies it without a second activation call.

The initialization call and local database commit are not one distributed transaction. A timeout/process loss before the local completion marker can leave a provider-side subscription whose outcome needs merchant reconciliation. Do not repeatedly resubmit initialization after an ambiguous outcome; inspect the merchant's subscription list and reconcile the saved state first. Automatic reconciliation of that ambiguous window, concurrent payment submissions, recurring-payment webhooks and real sandbox/live acceptance remain outstanding. Conversation IDs correlate requests; they are not claimed as provider idempotency keys. No real merchant API key or charge was used for the contract tests.

## Checks without an external account

```sh
(cd SaasManager && dotnet test ../tests/Registration.Security.Tests/Registration.Security.Tests.csproj -c Release)
python3 -m unittest discover -s scripts -p 'test_production_*.py' -v
```

The tests use the real application/provider/registration handlers and replace only the iyzico SDK boundary. They verify server entitlement, pending-to-active transition, price/identity checks, explicit mode/configuration, provider failures, metadata without credential copies, and successful-payment replay into the ordinary provisioning handler. They do not prove SDK transport, merchant acceptance or recurring settlement. A configured real merchant and the complete actual SaaS signup/payment UI still need separate acceptance.
