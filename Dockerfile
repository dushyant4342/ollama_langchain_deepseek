FROM amazonlinux:2

# Install necessary dependencies
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
    gcc \
    gcc-c++ \
    make \
    wget \
    tar \
    bzip2 \
    bzip2-devel \
    xz \
    xz-devel \
    zlib-devel \
    openssl-devel \
    libffi-devel

# Download and install Python 3.10
RUN wget https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz && \
    tar xvf Python-3.10.13.tgz && \
    cd Python-3.10.13 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    ln -s /usr/local/bin/python3.10 /usr/bin/python3 && \
    ln -s /usr/local/bin/pip3.10 /usr/bin/pip3

# Verify Python installation
RUN python3 --version && pip3 --version

# Copy and install dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt

# Copy app code and expose port
COPY . /app
EXPOSE 8501

CMD ollama serve & python3 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
