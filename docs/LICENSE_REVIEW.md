# License and asset review — 2026-10-14

Status: **private review version; public release is not cleared**. Repository visibility does not grant rights to the contents. No blanket license has been assigned to custom work whose ownership has not been confirmed. Existing third-party grants remain intact.

## Verified evidence and completed corrections

| Component | Evidence | Result |
| --- | --- | --- |
| GrandNode-derived commerce | `Ecommerce/LICENSE`; [upstream license](https://github.com/grandnode/grandnode2/blob/main/LICENSE) | GPLv3 retained. The modifications are described in `NOTICE.md`. Do not relabel this component MIT. |
| Fine Uploader and Roxy Fileman | Their `LICENSE` / `LICENSE.txt` under `Grand.SharedUIResources/wwwroot/administration` | The bundled copies carry GPLv3; retained regardless of newer upstream licensing. |
| Kendo Core | `kendo.ui.core.min.js` copyright/license header | Apache-2.0 header retained, version 2021.3.914. |
| Kendo Grid | `kendo.grid.js` lines 1–10 | The file identifies itself as **2014.1.318**, with GPLv3 or commercial terms. The enclosing 2021.3.914 folder is not the grid version. No commercial entitlement is assumed. |
| Administration theme | `administration/License.txt` | MIT attribution to Aigars Silkalns, Colorlib and Morteza Karimi retained. This does not establish rights to every separately bundled asset. |
| Local nb_utils fork | `Platforms/modules/nb_utils/LICENSE` | MIT attribution to Bhoomin Naik retained; embedded assets need their own provenance. |
| Urbanist fonts | Embedded font name records: Urbanist 1.303, project authors, OFL 1.1; [upstream notice](https://github.com/google/fonts/blob/main/ofl/urbanist/OFL.txt) | Restored missing `assets/fonts/urbanist/OFL.txt` beside the five fonts. |
| Poppins fonts | Embedded font name records: Poppins 4.004, project authors, OFL 1.1; [upstream notice](https://github.com/google/fonts/blob/main/ofl/poppins/OFL.txt) | Restored missing `Theme.Modern/Content/css/fonts/OFL.txt` beside the six fonts. This file applies to Poppins, not Simple-Line-Icons. |
| Runtime documents | Two order PDFs in a web export directory | Removed before private publication, including from the published Git ancestry. The source guard and ignore rules now reject generated exports and uploaded files (except empty-directory placeholders). |

## Open items

| Item | Exact scope / evidence | Needed before public release |
| --- | --- | --- |
| Custom code ownership and licensing | SaaS manager, tenant worker, mobile app, integrations and custom changes | Owner confirms authorship, employer/client agreements and any purchased template provenance; chooses terms compatible with the relevant dependencies. A private upload is not that confirmation. |
| Local device-integrity plugin | `Platforms/modules/flutter_jailbreak_detection/LICENSE` still says TODO | Establish provenance and license, or replace the module. A similarly named package on pub.dev is not proof that this implementation has that package's license. |
| iOS security dependency | `Platforms/store_user_app/ios/Podfile.lock` resolves **IOSSecuritySuite 2.1.0**; [version-specific EULA](https://github.com/securing/IOSSecuritySuite/blob/2.1.0/LICENSE) | The EULA distinguishes free use from paid/commercial distribution. Review the intended use and entitlement or replace the dependency. iOS is outside the verified demo. Skipping runtime initialization does not remove a linked native dependency. |
| Android root detection | Plugin references RootBeer **0.1.1**; [upstream Apache-2.0 license](https://github.com/scottyab/rootbeer/blob/master/LICENSE) | Preserve package notices in any distributed Android build. This license does not license the local wrapper. |
| Simple Line Icons | Existing `administration/simple-line-icons/License.txt` contains GraphicBurger use/redistribution conditions | Establish which release the bundled font comes from and whether redistribution as source is allowed, or replace it with a clearly licensed set. Do not assume MIT from its name. |
| LineAwesome font in nb_utils | Embedded name is `LineAwesomeIcons`, copyright references fluttericon.com/fontello.com | Establish exact generated-font inputs and license. The current Icons8 project license alone does not establish provenance of this derived file. |
| Kendo and other icon fonts | `KendoUIGlyphs`, `WebComponentsIcons`, `kendoui`, Glyphicons, Summernote | Review font-specific notices and match exact versions; JavaScript licensing alone is not evidence for font rights. |
| Product photos, logos, illustrations, SVGs and sound | Every retained file is listed with a hash in `docs/licenses/assets.csv`, including duplicated GrandNode samples, Theme.Modern, mobile assets, social/provider/payment marks, notification audio, and local module examples | Supply original source/permission or replace unresolved assets. An upstream code license or a filename does not prove photo/trademark rights. Demo catalog data is synthetic, but legacy sample files still exist in source. |
| Geographic workbook | Two copies of `App_Data/turkey_states.xlsx` | Confirm dataset provenance and redistribution terms. |
| Resolved dependency notices | NuGet, npm, Dart, CocoaPods, Gradle and service images | Review version-specific and transitive licenses before a public source/binary release. The manifest inventory is not a complete SBOM or legal clearance. Redis/MongoDB/Keycloak/PostgreSQL images are downloaded by Compose; they are not vendored here. |

## Reproducing the inventory

After staging additions/deletions, run:

```sh
python3 scripts/asset_inventory.py
python3 scripts/asset_inventory.py --check
python3 scripts/check_public_source.py
```

`assets.csv` records every tracked image, font, media file, workbook, archive and Lottie asset with SHA-256 and review status. Duplicate files remain separate rows to avoid losing a redistribution location. `inputs.csv` records dependency manifests, locks and retained license/notice files with hashes. CI detects inventory drift; it does **not** turn unresolved rights into approvals.

No original project was modified. No original Git history, real service credential, signing file, runtime customer export or generated `.local` file is intended for publication. Previously used production credentials still require rotation by their owner; removing copies cannot revoke them.
