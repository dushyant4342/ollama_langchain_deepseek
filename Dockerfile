FROM amazonlinux:2

# Install Python 3.10 from Amazon repos
RUN amazon-linux-extras enable python3.10 && \
    yum clean metadata && \
    yum -y install python3.10 python3.10-devel

# Install development tools and SSL
RUN yum -y install \
    gcc \
    openssl \
    openssl-devel \
    libffi-devel \
    && yum clean all

# Create symlinks
RUN alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.10 1

# Verify and install pip
RUN python3 -m ensurepip --upgrade && \
    pip3 install --upgrade pip

# Copy and install requirements
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt

# Copy app code and expose port
COPY . /app
EXPOSE 8501

CMD ollama serve & python3 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
