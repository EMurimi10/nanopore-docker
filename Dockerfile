# Use an official base image with Ubuntu
FROM ubuntu:20.04

# Set noninteractive mode for installing packages
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-pip \
    python3-dev \
    git \
    wget \
    curl \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libffi-dev \
    libz-dev \
    pkg-config \
    bc \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set locale to avoid warnings
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LC_ALL en_US.UTF-8

# Install Minimap2 for read alignment
RUN apt-get update && apt-get install -y \
    minimap2 \
    && apt-get clean

# Install SAMtools for working with SAM/BAM files
RUN apt-get install -y samtools

# Install Medaka for polishing consensus sequences from Nanopore data
RUN pip3 install medaka

# Install NanoPlot and NanoFilt for plotting and filtering Nanopore reads
RUN pip3 install NanoPlot NanoFilt

# Install Porechop for read trimming
RUN git clone https://github.com/rrwick/Porechop.git /opt/Porechop && \
    cd /opt/Porechop && \
    python3 setup.py install

# Install Filtlong for quality-based read filtering
RUN git clone https://github.com/rrwick/Filtlong.git /opt/Filtlong && \
    cd /opt/Filtlong && \
    make && \
    cp bin/filtlong /usr/local/bin/  # Changed this line

# Install PycoQC for QC reporting of Nanopore sequencing data
RUN pip3 install pycoqc

# Set the working directory
WORKDIR /workspace

# Default command when the container is run
CMD ["/bin/bash"]
