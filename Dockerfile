# Use Amazon Linux base image
FROM amazonlinux:2

# Install development tools and dependencies
RUN yum groupinstall -y "Development Tools" && \
    yum install -y \
    gcc \
    openssl11 \
    openssl11-devel \
    bzip2-devel \
    libffi-devel \
    wget \
    make \
    tar \
    gzip

# Download and install Python 3.10.14
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz && \
    tar xzf Python-3.10.14.tgz && \
    cd Python-3.10.14 && \
    ./configure --enable-optimizations --with-openssl=/usr/include/openssl11 && \
    make altinstall

# Ensure pip is up to date
RUN /usr/local/bin/python3.10 -m ensurepip --upgrade && \
    /usr/local/bin/python3.10 -m pip install --upgrade pip

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN /usr/local/bin/python3.10 -m pip install -r requirements.txt

# Copy app code
COPY . /app

# Expose Streamlit port
EXPOSE 8501

# Start Ollama & Streamlit
CMD ollama serve & streamlit run app.py --server.port=8501 --server.address=0.0.0.0
