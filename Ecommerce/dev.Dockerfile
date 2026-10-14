# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0.204 AS build-env
LABEL stage=build-env
WORKDIR /app

# Copy 
COPY ./src/ /app/

ARG GIT_COMMIT
ARG GIT_BRANCH
ARG BUILD_TYPE
ARG PROJECT_NAME

RUN ls -la /app/Web/$PROJECT_NAME/Plugins/

RUN rm -rf /app/Web/$PROJECT_NAME/Plugins/*
# Build plugins
RUN for plugin in /app/Plugins/*; \
    do \
      dotnet build "$plugin" -c Development -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH -p:BuildType=$BUILD_TYPE; \
    done 

# Build plugins
RUN for plugin in /app/AdminPlugins/*; \
    do \
      dotnet build "$plugin" -c Development -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH -p:BuildType=$BUILD_TYPE; \
    done

RUN ls -la /app/Web/$PROJECT_NAME/Plugins/
# Publish Web project
RUN dotnet publish /app/Web/$PROJECT_NAME/$PROJECT_NAME.csproj -c Development -o ./build/release -p:SourceRevisionId=$GIT_COMMIT -p:GitBranch=$GIT_BRANCH

# Runtime stage
FROM mcr.microsoft.com/dotnet/sdk:8.0.204 AS runtime
ARG PROJECT_NAME
ENV PROJECT_NAME=${PROJECT_NAME}
EXPOSE 8080
WORKDIR /app
COPY --from=build-env /app/build/release .
ENTRYPOINT ["sh", "-c", "dotnet /app/${PROJECT_NAME}.dll"]