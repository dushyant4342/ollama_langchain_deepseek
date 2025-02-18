FROM amazonlinux:2

# Install required packages including OpenSSL development files, tar, gzip, etc.
RUN yum install -y \
    tar \
    gzip \
    wget \
    gcc \
    openssl-devel \
    bzip2-devel \
    libffi-devel \
    zlib-devel \
    make

# Set environment variables so the compiler can find OpenSSL
ENV CPPFLAGS="-I/usr/include/openssl"
ENV LDFLAGS="-L/usr/lib64"

# Download and install Python 3.10.14 with SSL support
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz && \
    tar xzf Python-3.10.14.tgz && \
    cd Python-3.10.14 && \
    ./configure --enable-optimizations --with-openssl=/usr && \
    make altinstall

# Upgrade pip using the newly installed Python
RUN /usr/local/bin/python3.10 -m ensurepip --upgrade && \
    /usr/local/bin/python3.10 -m pip install --upgrade pip

# Copy and install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN /usr/local/bin/python3.10 -m pip install -r requirements.txt

# Copy app code and expose port
COPY . /app
EXPOSE 8501

CMD ollama serve & /usr/local/bin/python3.10 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
