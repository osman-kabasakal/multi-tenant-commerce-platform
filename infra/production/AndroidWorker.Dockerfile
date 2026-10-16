# syntax=docker/dockerfile:1
# Build only from the matching committed server image and a tracked-only mobile source package.
ARG PLATFORM_SERVER_IMAGE=commerce-platform:local
FROM ${PLATFORM_SERVER_IMAGE}
ARG PLATFORM_UID=1000
ARG PLATFORM_GID=1000
ARG ACCEPT_ANDROID_SDK_LICENSES=false
USER 0
RUN test "$ACCEPT_ANDROID_SDK_LICENSES" = true && test "$(dpkg --print-architecture)" = amd64 && \
    apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip python3 openjdk-17-jdk-headless libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    ANDROID_HOME=/opt/android-sdk ANDROID_SDK_ROOT=/opt/android-sdk \
    FLUTTER_ROOT=/opt/flutter \
    PUB_CACHE=/var/lib/commerce/mobile-cache/pub \
    GRADLE_USER_HOME=/var/lib/commerce/mobile-cache/gradle \
    XDG_CONFIG_HOME=/var/lib/commerce/mobile-cache/config
RUN curl --fail --location --silent --show-error \
      https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -o /tmp/android-tools.zip && \
    echo '7ec965280a073311c339e571cd5de778b9975026cfcbe79f2b1cdcb1e15317ee  /tmp/android-tools.zip' | sha256sum --check - && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    unzip -q /tmp/android-tools.zip -d /opt/android-sdk/cmdline-tools && \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/19.0 && \
    rm /tmp/android-tools.zip && \
    yes | /opt/android-sdk/cmdline-tools/19.0/bin/sdkmanager --sdk_root=/opt/android-sdk --licenses >/dev/null
RUN for attempt in 1 2 3; do \
      /opt/android-sdk/cmdline-tools/19.0/bin/sdkmanager --sdk_root=/opt/android-sdk \
        'platforms;android-31' 'platforms;android-35' 'platforms;android-36' 'build-tools;35.0.0' \
        'ndk;28.2.13676358' 'cmake;3.22.1' 'platform-tools' && break; \
      if [ "$attempt" -eq 3 ]; then exit 1; fi; \
    done && \
    test -s /opt/android-sdk/platforms/android-31/android.jar && \
    test -s /opt/android-sdk/platforms/android-35/android.jar && \
    test -s /opt/android-sdk/platforms/android-36/android.jar
RUN git clone --depth 1 --branch 3.44.6 https://github.com/flutter/flutter.git /opt/flutter && \
    test "$(git -C /opt/flutter rev-parse HEAD)" = ee80f08bbf97172ec030b8751ceab557177a34a6 && \
    mkdir -p /var/lib/commerce/mobile-cache /tmp/.android && \
    chown -R "$PLATFORM_UID:$PLATFORM_GID" /opt/flutter /opt/android-sdk /var/lib/commerce/mobile-cache /tmp/.android
COPY --chown=$PLATFORM_UID:$PLATFORM_GID mobile-source/ /app/mobile-source/
ENV PATH=/opt/flutter/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/cmdline-tools/19.0/bin:${PATH}
LABEL commerce.mobile.provider=AndroidAppDistribution
USER $PLATFORM_UID:$PLATFORM_GID
RUN flutter config --no-analytics && flutter config --android-sdk /opt/android-sdk && \
    flutter precache --android --no-ios --no-web --no-linux --no-windows --no-macos
CMD ["worker"]
