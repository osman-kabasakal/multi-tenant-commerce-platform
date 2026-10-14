FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER root
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:9.0.101 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /app
COPY ["src/", "./"]
COPY ["Directory.Build.props", "./"]
COPY ["Directory.Packages.props", "./"]
RUN dotnet restore "Web/Web.csproj" --use-current-runtime

RUN dotnet build "Web/Web.csproj" -c Release -o /app/build --use-current-runtime

FROM node:20-alpine AS angular-build
WORKDIR /app
COPY ["src/Web/ClientApp/","."]
RUN npm install
RUN npm run build -- --configuration production


FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "Web/Web.csproj" -c Release -o /app/publish /p:UseAppHost=false --use-current-runtime
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
