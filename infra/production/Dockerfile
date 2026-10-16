# syntax=docker/dockerfile:1
# Build with the monorepo root as context. Runtime credentials are mounted later.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS publish8
WORKDIR /src/Ecommerce
COPY Ecommerce/ /src/Ecommerce/
COPY Shared/ /src/Shared/
COPY tools/Platform.Gateway/ /src/tools/Platform.Gateway/
COPY tools/Platform.RuntimeProbe/ /src/tools/Platform.RuntimeProbe/
RUN --mount=type=cache,id=commerce-nuget8,target=/root/.nuget/packages \
    dotnet publish src/Web/Grand.Web.MultiTenant/Grand.Web.MultiTenant.csproj -c Release -o /out/commerce -p:UseAppHost=false --nologo --verbosity quiet && \
    dotnet publish src/Web/Grand.Web.OnlyAdmin/Grand.Web.OnlyAdmin.csproj -c Release -o /out/admin -p:UseAppHost=false --nologo --verbosity quiet && \
    dotnet publish src/Installer/Grand.Installer.Cli/Grand.Installer.Cli.csproj -c Release -o /out/installer -p:UseAppHost=false --nologo --verbosity quiet && \
    dotnet publish ../tools/Platform.Gateway/Platform.Gateway.csproj -c Release -o /out/gateway -p:UseAppHost=false --nologo --verbosity quiet && \
    dotnet publish ../tools/Platform.RuntimeProbe/Platform.RuntimeProbe.csproj -c Release -o /out/runtime-probe8 -p:UseAppHost=false --nologo --verbosity quiet

FROM node:22-bookworm-slim AS node
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS publish9
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx
COPY SaasManager/ /src/SaasManager/
COPY TenantManager/ /src/TenantManager/
COPY Shared/ /src/Shared/
COPY tools/Platform.Bootstrap/ /src/tools/Platform.Bootstrap/
COPY tools/Platform.RuntimeProbe/ /src/tools/Platform.RuntimeProbe/
WORKDIR /src/SaasManager
RUN --mount=type=cache,id=commerce-nuget9,target=/root/.nuget/packages \
    --mount=type=cache,id=commerce-npm,target=/root/.npm \
    dotnet publish src/Web/Web.csproj -c Release -o /out/saas -p:UseAppHost=false --nologo --verbosity quiet && \
    dotnet publish ../tools/Platform.Bootstrap/Platform.Bootstrap.csproj -c Release -o /out/bootstrap -p:UseAppHost=false --nologo --verbosity quiet && \
    dotnet publish ../tools/Platform.RuntimeProbe/Platform.RuntimeProbe.csproj -c Release -o /out/runtime-probe9 -p:RuntimeProbeFramework=net9.0 -p:UseAppHost=false --nologo --verbosity quiet
WORKDIR /src/TenantManager
RUN --mount=type=cache,id=commerce-nuget9,target=/root/.nuget/packages \
    dotnet publish TenantManager.csproj -c Release -o /out/worker -p:UseAppHost=false --nologo --verbosity quiet

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime8
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
ARG PLATFORM_UID=1000
ARG PLATFORM_GID=1000
ARG SOURCE_REVISION=unknown
RUN mkdir -p /run/platform-runtime && chown "$PLATFORM_UID:$PLATFORM_GID" /run/platform-runtime && chmod 700 /run/platform-runtime
LABEL org.opencontainers.image.source="https://github.com/osman-kabasakal/multi-tenant-commerce-platform" \
      org.opencontainers.image.revision=$SOURCE_REVISION
# The .NET 9 host runs the worker; its installer subprocess needs the .NET 8 shared frameworks.
COPY --from=runtime8 /usr/share/dotnet/shared/ /usr/share/dotnet/shared/
COPY --from=publish8 --chown=$PLATFORM_UID:$PLATFORM_GID /out/ /app/
COPY --from=publish9 --chown=$PLATFORM_UID:$PLATFORM_GID /out/ /app/
COPY --chmod=0555 infra/production/entrypoint.sh /usr/local/bin/platform
ENV ASPNETCORE_ENVIRONMENT=Production DOTNET_ENVIRONMENT=Production \
    DOTNET_NOLOGO=true DOTNET_CLI_TELEMETRY_OPTOUT=true HOME=/tmp XDG_RUNTIME_DIR=/run/platform-runtime
WORKDIR /app
USER $PLATFORM_UID:$PLATFORM_GID
ENTRYPOINT ["/usr/local/bin/platform"]
CMD ["help"]
