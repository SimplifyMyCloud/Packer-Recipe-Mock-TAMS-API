#!/bin/bash
set -e

# Update system and install dependencies
sudo dnf update -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install -y \
    autoconf \
    automake \
    bzip2 \
    bzip2-devel \
    cmake \
    freetype-devel \
    gcc \
    gcc-c++ \
    git \
    libtool \
    make \
    pkgconfig \
    python39 \
    zlib-devel \
    harfbuzz-devel \
    vim

# Install Docker and Docker Compose
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf -y install docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

# Start and enable Docker
sudo systemctl --now enable docker

# Enable non-root user to run Docker commands
# Add the current user
sudo usermod -a -G docker $(whoami)


# Create build directory
mkdir -p ~/ffmpeg_sources ~/ffmpeg_build ~/bin

# Install NASM
cd ~/ffmpeg_sources
curl -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2
tar xjvf nasm-2.15.05.tar.bz2
cd nasm-2.15.05
./autogen.sh
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make -j$(nproc)
make install

# Install YASM
cd ~/ffmpeg_sources
curl -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make -j$(nproc)
make install

# Install libx264
cd ~/ffmpeg_sources
git clone --branch stable --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make -j$(nproc)
make install

# Install libfdk-aac
cd ~/ffmpeg_sources
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make -j$(nproc)
make install

# Install libmp3lame
cd ~/ffmpeg_sources
curl -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make -j$(nproc)
make install

# Install libopus
cd ~/ffmpeg_sources
curl -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
tar xzvf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make -j$(nproc)
make install

# Install libvpx
cd ~/ffmpeg_sources
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make -j$(nproc)
make install

# Install FFmpeg
cd ~/ffmpeg_sources
curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libharfbuzz \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree
make -j$(nproc)
make install

# Make FFmpeg available system-wide
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
sudo ln -s ~/bin/ffmpeg /usr/local/bin/
sudo ln -s ~/bin/ffprobe /usr/local/bin/

# Verify installation
ffmpeg -version

# Install example media files
git clone https://github.com/bbc/tams.git
cd tams/examples
make sample_content

# Setup aliases
echo 'alias la="ls -alh"' >> ~/.bashrc
echo 'alias ..="cd ../"' >> ~/.bashrc
