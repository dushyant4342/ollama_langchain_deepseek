FROM amazonlinux:2023

# Install dependencies
RUN dnf install -y python3.11 python3.11-devel curl tar gzip --allowerasing && \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    python3 -m ensurepip --default-pip && \
    python3 -m pip install --upgrade pip

# Verify Python and Pip installation
RUN python3 --version && python3 -m pip --version

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Set the working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create a startup script
RUN echo '#!/bin/bash\n\
# Start Ollama in the background\n\
/root/.ollama/bin/ollama serve &\n\
# Wait for Ollama to start\n\
sleep 10\n\
# Pull the model if not already present\n\
/root/.ollama/bin/ollama pull deepseek-r1:1.5b\n\
# Start Streamlit\n\
python3 -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0\n\
' > /app/start.sh

# Make the startup script executable
RUN chmod +x /app/start.sh

# Expose ports
EXPOSE 8501
EXPOSE 11434

# Set the entrypoint to our startup script
ENTRYPOINT ["/app/start.sh"]
