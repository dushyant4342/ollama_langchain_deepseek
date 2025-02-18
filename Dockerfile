# Use Amazon Linux base image
FROM amazonlinux:2

# Install dependencies
RUN yum install -y python3 python3-pip git && \
    python3 -m pip install --upgrade pip  # This ensures upgrading pip using the Python package manager

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt  # Use --no-cache-dir to avoid caching issues

# Copy app code
COPY . /app

# Expose Streamlit port
EXPOSE 8501

# Start Ollama & Streamlit
CMD ollama serve & streamlit run app.py --server.port=8501 --server.address=0.0.0.0
