# Build with the monorepo root as context.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src/Ecommerce
COPY Ecommerce/ /src/Ecommerce/
COPY Shared/ /src/Shared/
RUN dotnet publish src/Web/Grand.Web.MultiTenant/Grand.Web.MultiTenant.csproj -c Release -o /app/publish -p:BuildType=Frontend -p:PublishTenantPlugins=true -p:UseAppHost=false
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
USER $APP_UID
EXPOSE 8080
ENTRYPOINT ["dotnet", "Grand.Web.MultiTenant.dll"]
