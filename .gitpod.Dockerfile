FROM gitpod/workspace-full

USER root

# Install Perl, gunzip, pip, unzip, curl
RUN apt-get update && apt-get install -y \
    perl \
    gzip \
    python3-pip \
    unzip \
    curl

# Install Cutadapt and other Python packages
RUN pip3 install cutadapt

# Download and install FastQC
RUN curl -fsSL -o fastqc.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && \
    unzip fastqc.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/FastQC/fastqc

# Install Trim Galore
RUN curl -fsSL -o trim_galore.tar.gz https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz && \
    tar -xvzf trim_galore.tar.gz -C /usr/local/bin/

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
