FROM debian:bookworm

RUN apt-get update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa ninja-build libgtk-3-dev libwebkit2gtk-4.0-dev keybinder-3.0 clang cmake

RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
ENV PATH="/flutter/bin:$PATH"
RUN flutter doctor
