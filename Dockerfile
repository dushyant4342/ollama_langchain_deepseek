FROM amazonlinux:2023

# Install Python 3.11 (default in Amazon Linux 2023)
RUN dnf install -y python3.11 python3.11-devel python3-pip && \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.11 1

# Verify Python and Pip installation
RUN python3 --version && pip3 --version

# Set the working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port for Streamlit
EXPOSE 8501

# Start Ollama and Streamlit
CMD ollama serve & python3 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
