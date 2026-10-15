FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER root
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src/SaasManager
COPY SaasManager/ /src/SaasManager/
COPY Shared/ /src/Shared/
RUN dotnet restore src/Web/Web.csproj
RUN dotnet build src/Web/Web.csproj -c Release --no-restore

FROM node:22-alpine AS angular-build
WORKDIR /app
COPY ["SaasManager/src/Web/ClientApp/","."]
RUN npm ci
RUN npm run build -- --configuration production


FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "src/Web/Web.csproj" -c Release -o /app/publish /p:UseAppHost=false --use-current-runtime
FROM base AS final
#ENV ASPNETCORE_HOSTINGSTARTUPASSEMBLIES="Microsoft.AspNetCore.SpaProxy"
ENV ASPNETCORE_ENVIRONMENT=Production   
WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=angular-build /app/dist/browser/. ./wwwroot/
USER root
RUN adduser saas
RUN chown -R saas:saas /app/wwwroot
USER saas
EXPOSE 5001
ENTRYPOINT ["dotnet", "SaasManager.Web.dll"]
