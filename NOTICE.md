# Local changes and attribution

This monorepo brings together GrandNode-derived commerce and author-owned SaaS, tenant orchestration, mobile integration and deployment tools. Original upstream copyright and component licenses remain in force. The SaaS foundation identifies Clean.Architecture.Solution.Template 9.0.5; its publisher's MIT notice is retained separately from author-owned business and integration code. Osman Kabasakal's independent contributions are licensed GPL-3.0-only; see [LICENSING.md](LICENSING.md).

The commerce work adds tenant routing/database boundaries, validated gateway tokens, shared secret access, ordered tenant installation, distributed notifications/cache and separate tenant scheduling. The platform adds durable provisioning/build plans, domain ownership, versioned mobile identities and signing records, tenant branding, Android/iOS delivery verification, and portable Linux/Oracle operations. These are integration and platform contributions; GrandNode's existing commerce engine is credited to its upstream authors.

Open-source preparation changes dated 2026-10-18 include:

- Restored full GPL text at the root and retained the commerce/component notices.
- Recorded author ownership of SaaS/TenantManager and independent Flutter screens/Riverpod/API code; the purchased UI kit itself is excluded.
- Restored all preparation-time image/icon changes at the maintainer's request, including the Famizyo logo, sample photos, Flutter defaults, flags and icon fonts. Restored the original Flutter theme, LineIcons API/CSS mappings, sound and geography fixtures.
- Retained existing assets without asserting a new license where file-specific clearance is unconfirmed; see [asset retention decision](docs/licenses/ASSET_RETENTION.md).
- Kept the IRANSans-to-OFL-Vazirmatn correction and missing font notices. Restored B_Yekan/Yekan-modified and LineAwesome instead of classifying uncertain origin as a proven restriction.
- Pinned IOSSecuritySuite to the BSD-2-Clause 1.9.11 release and retained RootBeer/reference notices. This is a licensing compatibility choice, not a claim of complete/current device integrity coverage.
- Added per-file hashes that distinguish license evidence from explicit asset retention, plus release/inventory checks. Removed the reverted artwork generators.
- Rewrote the README, architecture, technology guide, roadmap and retrospective ADRs around actual working scope and dated validation.

No original source repository is modified by this preparation. Private runtime/customer exports, signing material, actual tenant logos, cloud credentials and MaxMind datasets are excluded. Original private Git ancestry is not suitable for direct public exposure merely because today's working files are clean. [Release preparation](docs/PUBLIC_RELEASE.md).
