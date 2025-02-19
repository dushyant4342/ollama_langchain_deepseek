FROM amazonlinux:2023

# Install Python 3.10 (Amazon Linux 2023 provides 3.11 instead)
RUN dnf install -y python3.11 python3.11-devel && \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.11 1

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
