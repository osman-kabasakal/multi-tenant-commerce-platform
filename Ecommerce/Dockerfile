# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
LABEL stage=build-env
WORKDIR /src/Ecommerce

# Copy 
COPY Ecommerce/ /src/Ecommerce/
COPY Shared/ /src/Shared/

ARG GIT_COMMIT
ARG GIT_BRANCH
ARG BUILD_TYPE
ARG PROJECT_NAME

# Set PROJECT_FOLDER and PROJECT_NAME based on BUILD_TYPE
RUN case "$BUILD_TYPE" in \
        "Installer") \
            echo "PROJECT_FOLDER=Installer" >> /etc/environment && \
            echo "PROJECT_NAME=Grand.Installer.Cli" >> /etc/environment \
            ;; \
        "Background") \
            echo "PROJECT_FOLDER=Cli" >> /etc/environment && \
            echo "PROJECT_NAME=Grand.BackgroundJobExecuter" >> /etc/environment \
            ;; \
        "Backend") \
            echo "PROJECT_FOLDER=Web" >> /etc/environment && \
            echo "PROJECT_NAME=Grand.Web.OnlyAdmin" >> /etc/environment \
            ;; \
        "Frontend") \
            echo "PROJECT_FOLDER=Web" >> /etc/environment && \
            echo "PROJECT_NAME=Grand.Web.MultiTenant" >> /etc/environment \
            ;; \
        *) \
            echo "Error: Invalid BUILD_TYPE. Must be Installer, Background, Backend, or Frontend" \
            exit 1 \
            ;; \
    esac && \
    . /etc/environment && \
    mkdir -p /src/Ecommerce/src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/ || true && \
    ls -la /src/Ecommerce/src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/ || true

# Use the environment variables in subsequent commands
RUN . /etc/environment && mkdir -p /src/Ecommerce/src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/ && rm -rf /src/Ecommerce/src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/**
# Build plugins
RUN . /etc/environment && for plugin in /src/Ecommerce/src/Plugins/*; \
    do \
      dotnet build "$plugin" -c Release -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH -p:BuildType=$BUILD_TYPE; \
    done 

# Build AdminPlugins only if BUILD_TYPE is Backend
RUN . /etc/environment && if [ "$BUILD_TYPE" != "Frontend" ]; then \
      for plugin in /src/Ecommerce/src/AdminPlugins/*; \
      do \
        dotnet build "$plugin" -c Release -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH -p:BuildType=$BUILD_TYPE; \
      done; \
    fi

RUN . /etc/environment && ls -la /src/Ecommerce/src/$PROJECT_FOLDER/$PROJECT_NAME/Plugins/ || true
# Publish Web project
RUN . /etc/environment && dotnet publish /src/Ecommerce/src/$PROJECT_FOLDER/$PROJECT_NAME/$PROJECT_NAME.csproj -c Release -o /app/build/release -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
EXPOSE 8080
WORKDIR /app
COPY --from=build-env /app/build/release .
COPY --from=build-env /etc/environment /etc/environment
RUN . /etc/environment && echo "Will run: dotnet /app/${PROJECT_NAME}.dll"
ENTRYPOINT ["sh", "-c", ". /etc/environment && dotnet /app/${PROJECT_NAME}.dll"]