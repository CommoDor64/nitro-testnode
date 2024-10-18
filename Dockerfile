# Use the official Ubuntu 20.04 as base image
FROM ubuntu:24.04

# Disable interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    jq \
    nodejs \
    npm \
    golang \
    curl \
    ca-certificates \
    git \
    bash \
    libunwind8 \
    docker.io \
    docker-compose-v2

# Install Rust non-interactively
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Set environment variable for Rust
ENV PATH="/root/.cargo/bin:${PATH}"

# Add wasm32 target for Rust
RUN rustup target add wasm32-unknown-unknown

# ARG DFX_VERSION
ENV DFX_VERSION=0.23.0
RUN DFXVM_INIT_YES=true sh -ci "$(curl -fsSL https://sdk.dfinity.org/install.sh)"
RUN . $HOME/.local/share/dfx/env
ENV PATH="/root/.local/share/dfx/bin:$PATH"

## Set environment variable for DFX
#ENV PATH="/root/bin:${PATH}"

# Install Foundry non-interactively
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup

# Set environment variable for Foundry
ENV PATH="/root/.foundry/bin:${PATH}"

# Create and set the working directory
WORKDIR /nitro-icda-poc

ENV NITRO_CONTRACTS_BRANCH=3fd3313

# Default command
CMD ["bash"]


