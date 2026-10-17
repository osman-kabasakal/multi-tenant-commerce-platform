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

RUN ls -la /src/Ecommerce/src/Web/$PROJECT_NAME/Plugins/

RUN rm -rf /src/Ecommerce/src/Web/$PROJECT_NAME/Plugins/*
# Build plugins
RUN for plugin in /src/Ecommerce/src/Plugins/*; \
    do \
      dotnet build "$plugin" -c Debug -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH -p:BuildType=$BUILD_TYPE; \
    done 

# Admin plugins are included in every target except Frontend.
RUN if [ "$BUILD_TYPE" != "Frontend" ]; then \
      for plugin in /src/Ecommerce/src/AdminPlugins/*; \
      do \
        dotnet build "$plugin" -c Debug -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH -p:BuildType=$BUILD_TYPE; \
      done; \
    fi

RUN ls -la /src/Ecommerce/src/Web/$PROJECT_NAME/Plugins/
# Publish Web project
RUN dotnet publish /src/Ecommerce/src/Web/$PROJECT_NAME/$PROJECT_NAME.csproj -c Debug -o /app/build/release -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH -p:BuildType=$BUILD_TYPE

# Runtime stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS runtime
ARG PROJECT_NAME
ENV PROJECT_NAME=${PROJECT_NAME}
EXPOSE 8080
WORKDIR /app
COPY --from=build-env /app/build/release .
ENTRYPOINT ["sh", "-c", "dotnet /app/${PROJECT_NAME}.dll"]