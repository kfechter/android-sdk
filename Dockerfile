FROM ubuntu:24.04

ENV ANDROID_HOME /opt/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/bin

ADD start-default-emulator.sh /opt

RUN mkdir /opt/android

RUN apt update \
  &&DEBIAN_FRONTEND=noninteractive apt install openjdk-17-jdk wget unzip git -y \
  && chmod a+x /opt/start-default-emulator.sh \
  && wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -qO android-sdk.zip \
  && unzip android-sdk.zip -d /opt/android \
  && rm android-sdk.zip \
  && mkdir -p /opt/android/tools/jaxb_lib \
  && wget https://repo1.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar -O /opt/android/tools/jaxb_lib/activation.jar \
  && wget https://repo1.maven.org/maven2/com/sun/xml/bind/jaxb-impl/2.3.3/jaxb-impl-2.3.3.jar -O /opt/android/tools/jaxb_lib/jaxb-impl.jar \
  && wget https://repo1.maven.org/maven2/com/sun/istack/istack-commons-runtime/3.0.11/istack-commons-runtime-3.0.11.jar -O /opt/android/tools/jaxb_lib/istack-commons-runtime.jar \
  && wget https://repo1.maven.org/maven2/org/glassfish/jaxb/jaxb-xjc/2.3.3/jaxb-xjc-2.3.3.jar -O /opt/android/tools/jaxb_lib/jaxb-xjc.jar \
  && wget https://repo1.maven.org/maven2/org/glassfish/jaxb/jaxb-core/2.3.0.1/jaxb-core-2.3.0.1.jar -O /opt/android/tools/jaxb_lib/jaxb-core.jar \
  && wget https://repo1.maven.org/maven2/org/glassfish/jaxb/jaxb-jxc/2.3.3/jaxb-jxc-2.3.3.jar -O /opt/android/tools/jaxb_lib/jaxb-jxc.jar \
  && wget https://repo1.maven.org/maven2/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.jar -O /opt/android/tools/jaxb_lib/jaxb-api.jar \
  && echo "y" | sdkmanager --sdk_root=/opt/android "tools" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "platform-tools" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "build-tools;35.0.0-rc3" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "extras;android;m2repository" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "extras;google;m2repository" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "emulator" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "platforms;android-35" \
  && echo "y" | sdkmanager --sdk_root=/opt/android "system-images;android-35;google_apis;x86_64" \
  && echo "y" | sdkmanager --sdk_root=/opt/android --update \
  && sed -ie 's%^CLASSPATH=.*%\0:/opt/android/tools/jaxb_lib/*%' /opt/android/bin/avdmanager
  && echo "no" | avdmanager create avd -n default -k "system-images;android-35;google_apis;x86_64" -d 17 \
  && rm -rf /var/lib/apt/lists/*
