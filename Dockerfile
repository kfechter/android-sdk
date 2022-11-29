FROM ubuntu:20.04

ENV ANDROID_HOME /opt/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/bin

ADD start-default-emulator.sh /opt

RUN mkdir /opt/android

RUN apt update \
  &&DEBIAN_FRONTEND=noninteractive apt install openjdk-8-jdk wget unzip git -y \
  && chmod a+x /opt/start-default-emulator.sh \
  && wget https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip -qO android-sdk.zip \
  && unzip android-sdk.zip -d /opt/android \
  && rm android-sdk.zip \
  && echo "y" | sdkmanager --sdk_root=/opt/android "tools" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "platform-tools" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "build-tools;33.0.1" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "extras;android;m2repository" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "extras;google;m2repository" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "emulator" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "platforms;android-28" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "system-images;android-28;google_apis;x86" \
  && echo "y" | sdkmanager --sdk_root=/opt/android --update \
  && echo "no" | avdmanager create avd -n default -k "system-images;android-28;google_apis;x86" -d 17 \
  &&DEBIAN_FRONTEND=noninteractive apt remove openjdk-8-jdk -y \
  &&DEBIAN_FRONTEND=noninteractive apt install openjdk-11-jdk -y \
  && rm -rf /var/lib/apt/lists/*
