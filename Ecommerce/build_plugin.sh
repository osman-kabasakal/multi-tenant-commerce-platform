#!/bin/bash

# Env dosyasını yükle
if [ -f build.env ]; then
    source build.env
else
    echo "Error: .env file not found"
    exit 1
fi

# Build type'a göre project folder ve name'i belirle
case "$BUILD_TYPE" in
    "Installer")
        PROJECT_FOLDER="Installer"
        PROJECT_NAME="Grand.Installer.Cli"
        ;;
    "Backend")
        PROJECT_FOLDER="Web"
        PROJECT_NAME="Grand.Web.OnlyAdmin"
        ;;
    "Frontend")
        PROJECT_FOLDER="Web"
        PROJECT_NAME="Grand.Web.MultiTenant"
        ;;
    *)
        echo "Error: Invalid BUILD_TYPE. Must be Installer, Backend, or Frontend"
        exit 1
        ;;
esac

# Mevcut plugin klasörünü temizle
PLUGIN="Shipping.FixedRateShipping"
PLUGIN_FOLDER="Plugins"
rm -rf "./src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/$PLUGIN/"*
rm -rf "./src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/bin/"*

dotnet build "./src/$PLUGIN_FOLDER/$PLUGIN" -c "$CONFIGURATION" \
            -p:SourceRevisionId="$GIT_COMMIT" \
            -p:GitBranch="$GIT_BRANCH" \
            -p:BuildType="$BUILD_TYPE"