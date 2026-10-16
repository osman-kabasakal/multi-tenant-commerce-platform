import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        if (project.extra.has("platformTenant")) {
            @Suppress("UNCHECKED_CAST")
            val tenant = project.extra["platformTenant"] as Map<String, Any>
            create("tenant") {
                dimension = "flavor-type"
                applicationId = tenant.getValue("androidApplicationId") as String
                manifestPlaceholders["deepLinkHost"] = tenant.getValue("deepLinkHost") as String
            }
        }
        create("demo") {
            dimension = "flavor-type"
            applicationId = "dev.commerce.demo"
            manifestPlaceholders["deepLinkHost"] = "demo-a.localhost"
            resValue(type = "string", name = "app_name", value = "Commerce Demo")
        }
    }
}