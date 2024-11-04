# Packer Recipe Mock TAMS API

_Packer recipe to bake a AWS Rocky Linux 8 AMI that has the Mock TAMS API running + sample media_

### Links

* [awslabs - TAMS Implementation](https://github.com/awslabs/time-addressable-media-store)

* [BBC - TAMS](https://github.com/bbc/tams)

* [TAMS Docs](https://bbc.github.io/tams/main/index.html#/)

* [TAMS Example](https://github.com/bbc/tams/blob/main/examples/README.md)

* [FFmpeg Install](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos)

### Files

`aws-ami-tams-mock-api-example.pkr.hcl`

The Packer configuration file that:

* Uses the official Rocky Linux 8 AMI as base
* Provisions a t3.medium instance (compilation needs decent CPU/memory)
* Creates a 40GB GP3 volume
* Tags the AMI appropriately


`configuration-state.sh`

The build script that:

* Installs all required dependencies
* Compiles NASM and YASM for better performance
* Builds all required libraries (`x264`, `x265`, `libfdk-aac`, etc.)
* Compiles FFmpeg with all common codecs and features
* Makes FFmpeg available system-wide
* Added parallel compilation with `-j$(nproc)` for faster builds
* Installs Python & builds virtual environment
* Downloads media [Big Buck Bunny](https://peach.blender.org/) for demo use

### RunBooks

* [Packer Build](RunBook-PackerBake.md)

* [TAMS Example](RunBook-TAMSExample.md)