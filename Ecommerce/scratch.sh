#!/bin/bash

# Env dosyasını yükle
if [ -f build.env ]; then
    source build.env
else
    echo "Error: .env file not found"
    exit 1
fi

# Build type'a göre project folder ve name'i belirle Uploader
case "$BUILD_TYPE" in
    "Installer")
        PROJECT_FOLDER="Installer"
        PROJECT_NAME="Grand.Installer.Cli"
        ;;
    "Uploader")
            PROJECT_FOLDER="Installer"
            PROJECT_NAME="Grand.Data.Uploader"
            ;;
    "Background")
            PROJECT_FOLDER="Cli"
            PROJECT_NAME="Grand.BackgroundJobExecuter"
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
rm -rf "./src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/"*

# Normal pluginleri build et
for plugin in ./src/Plugins/*; do 
    if [ -d "$plugin" ]; then
        dotnet build "$plugin" -c "$CONFIGURATION" \
            -p:SourceRevisionId="$GIT_COMMIT" \
            -p:GitBranch="$GIT_BRANCH" \
            -p:BuildType="$BUILD_TYPE"
    fi
done

# Admin pluginleri build et
if [ "$BUILD_TYPE" != "Frontend" ]; then
for plugin in ./src/AdminPlugins/*; do 
    if [ -d "$plugin" ]; then
        dotnet build "$plugin" -c "$CONFIGURATION" \
            -p:SourceRevisionId="$GIT_COMMIT" \
            -p:GitBranch="$GIT_BRANCH" \
            -p:BuildType="$BUILD_TYPE"
    fi
done
fi

# Eğer PUBLISH ve PUBLISH_FOLDER varsa publish işlemini gerçekleştir
if [ -n "$PUBLISH" ] && [ -n "$PUBLISH_FOLDER" ]; then
    dotnet publish "./src/$PROJECT_FOLDER/$PROJECT_NAME/$PROJECT_NAME.csproj" \
        -c "$CONFIGURATION" \
        -o "$PUBLISH_FOLDER" \
        -p:SourceRevisionId="$GIT_COMMIT" \
        -p:GitBranch="$GIT_BRANCH" \
        -p:BuildType="$BUILD_TYPE"
fi
