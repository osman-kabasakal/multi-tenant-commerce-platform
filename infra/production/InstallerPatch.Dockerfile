# syntax=docker/dockerfile:1
# The operator first proves that every other runtime source is unchanged.
ARG BASE_SERVER_IMAGE
ARG BASE_ANDROID_IMAGE
FROM mcr.microsoft.com/dotnet/sdk:8.0@sha256:f7e28a0a3f6f9235929ec19274fd0ddf8534e9159f99fac602ac73304f1ce99f AS installer
WORKDIR /src/Ecommerce
COPY Ecommerce/ /src/Ecommerce/
COPY Shared/ /src/Shared/
RUN --mount=type=cache,id=commerce-nuget8,target=/root/.nuget/packages \
    dotnet publish src/Installer/Grand.Installer.Cli/Grand.Installer.Cli.csproj -c Release -o /out/installer \
      -p:BuildType=Installer -p:PublishTenantPlugins=true -p:UseAppHost=false -m:1 --nologo --verbosity quiet && rm -rf /src

FROM ${BASE_SERVER_IMAGE} AS patched-server
ARG PLATFORM_UID
ARG PLATFORM_GID
ARG SOURCE_REVISION
ARG BASE_REVISION
USER 0
RUN rm -rf /app/installer
COPY --from=installer --chown=$PLATFORM_UID:$PLATFORM_GID /out/installer/ /app/installer/
LABEL org.opencontainers.image.revision=$SOURCE_REVISION commerce.image.component="installer" commerce.image.base-revision=$BASE_REVISION
USER $PLATFORM_UID:$PLATFORM_GID

FROM ${BASE_ANDROID_IMAGE} AS patched-android
ARG PLATFORM_UID
ARG PLATFORM_GID
ARG SOURCE_REVISION
ARG BASE_REVISION
USER 0
RUN rm -rf /app/installer
COPY --from=installer --chown=$PLATFORM_UID:$PLATFORM_GID /out/installer/ /app/installer/
LABEL org.opencontainers.image.revision=$SOURCE_REVISION commerce.image.component="installer" commerce.image.base-revision=$BASE_REVISION
USER $PLATFORM_UID:$PLATFORM_GID
