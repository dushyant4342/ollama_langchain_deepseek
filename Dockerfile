FROM amazonlinux:2

# Install required packages including OpenSSL development files
RUN yum update -y && yum install -y \
    tar \
    gzip \
    wget \
    gcc \
    openssl \
    openssl-devel \
    bzip2-devel \
    libffi-devel \
    zlib-devel \
    make \
    && yum clean all

# Download and install Python 3.10.14
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz && \
    tar xzf Python-3.10.14.tgz && \
    cd Python-3.10.14 && \
    ./configure \
        --with-openssl=/usr \
        --with-openssl-rpath=/usr/lib64 \
        --with-system-ffi \
        --enable-shared \
        && \
    make -j $(nproc) LDFLAGS="-Wl,-rpath /usr/local/lib" && \
    make install && \
    ldconfig && \
    cd .. && \
    rm -rf Python-3.10.14* && \
    rm -f /usr/local/bin/python3 /usr/local/bin/pip3 && \
    ln -sf /usr/local/bin/python3.10 /usr/local/bin/python3 && \
    ln -sf /usr/local/bin/pip3.10 /usr/local/bin/pip3

# Install requirements with SSL verification disabled (temporary workaround)
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN python3 -m pip install --trusted-host pypi.org \
    --trusted-host files.pythonhosted.org \
    -r requirements.txt

# Copy app code and expose port
COPY . /app
EXPOSE 8501

CMD ollama serve & python3 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
