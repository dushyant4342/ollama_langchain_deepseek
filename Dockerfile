# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Install necessary development tools, including gzip
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

# Download and install Python 3.10.14
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz && \
    tar xzf Python-3.10.14.tgz && \
    cd Python-3.10.14 && \
    ./configure --enable-optimizations && \
    make altinstall
    
# Ensure pip is up to date
RUN /usr/local/bin/python3.10 -m ensurepip --upgrade && \
    /usr/local/bin/python3.10 -m pip install --upgrade pip

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN /usr/local/bin/python3.10 -m pip install -r requirements.txt

# Copy application code
COPY . /app

# Expose the Streamlit port
EXPOSE 8501

# Start Ollama and Streamlit
CMD ollama serve & /usr/local/bin/python3.10 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
