FROM amazonlinux:2023

# Install Python 3.11 and required packages
RUN dnf install -y python3.11 python3.11-devel && \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    python3 -m ensurepip --default-pip && \
    python3 -m pip install --upgrade pip

# Verify Python and Pip installation
RUN python3 --version && python3 -m pip --version

# Set the working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port for Streamlit
EXPOSE 8501

# Start Ollama and Streamlit
CMD ollama serve & python3 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
