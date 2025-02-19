FROM amazonlinux:2023

# Install dependencies
RUN dnf install -y python3.11 python3.11-devel curl --allowerasing && \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    python3 -m ensurepip --default-pip && \
    python3 -m pip install --upgrade pip

# Verify Python and Pip installation
RUN python3 --version && python3 -m pip --version

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh
