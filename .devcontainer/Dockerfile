FROM debian:bookworm

RUN apt-get update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa ninja-build libgtk-3-dev libwebkit2gtk-4.0-dev keybinder-3.0 clang cmake android-sdk sdkmanager

RUN apt-get clean

ENV ANDROID_HOME="/usr/lib/android-sdk"
ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

RUN sdkmanager --install "cmdline-tools;latest"
RUN sdkmanager --install "platforms;android-35"

RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
ENV PATH="/flutter/bin:$PATH"
RUN yes | flutter doctor --android-licenses
RUN flutter doctor
