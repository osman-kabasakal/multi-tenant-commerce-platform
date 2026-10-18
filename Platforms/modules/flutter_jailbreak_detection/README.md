# Local device-integrity wrapper

This module is an application-owned Flutter method-channel wrapper, licensed GPL-3.0-only for the author's code. The author identifies it as a locally implemented module informed by existing jailbreak-detection examples, rather than a pinned upstream package fork. A BSD-3-Clause reference-project notice is retained in LICENSE and docs/licenses/upstream for attribution; it does not relabel all local code BSD.

Android uses RootBeer 0.1.1 (Apache-2.0), plus local device/install/signature helpers. iOS uses IOSSecuritySuite **1.9.11 (BSD-2-Clause)**, pinned explicitly because the 2.1.0 release has different EULA terms. The older pinned dependency has a separate maintenance/security tradeoff and is not represented as current device attestation.

Native packages keep their grants and notices. Root/jailbreak signals are best-effort and do not replace server-side tenant/user authorization or Play Integrity/App Attest.

See the monorepo LICENSING.md, THIRD_PARTY_NOTICES.md and docs/LICENSE_REVIEW.md for scope and version-specific texts.
