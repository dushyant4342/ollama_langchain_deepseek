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

# Set environment variables for SSL configuration
ENV CPPFLAGS="-I/usr/include/openssl"
ENV LDFLAGS="-L/usr/lib64"
ENV LD_LIBRARY_PATH="/usr/lib64:$LD_LIBRARY_PATH"

# Download and install Python 3.10.14 with explicit SSL configuration
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz && \
    tar xzf Python-3.10.14.tgz && \
    cd Python-3.10.14 && \
    ./configure \
        --enable-optimizations \
        --with-openssl=/usr \
        --with-ensurepip=install \
        LDFLAGS="-Wl,-rpath,/usr/lib64" && \
    make -j $(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.10.14*

# Verify SSL is working
RUN /usr/local/bin/python3.10 -c "import ssl; print(ssl.OPENSSL_VERSION)"

# Upgrade pip
RUN /usr/local/bin/python3.10 -m pip install --upgrade pip

# Copy and install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN /usr/local/bin/python3.10 -m pip install -r requirements.txt

# Copy app code and expose port
COPY . /app
EXPOSE 8501

CMD ollama serve & /usr/local/bin/python3.10 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
