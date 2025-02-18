# Use Amazon Linux base image
FROM amazonlinux:2

# Install dependencies
RUN yum install -y python3 python3-pip git && \
    pip3 install --upgrade pip

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3 install -r requirements.txt

# Copy app code
COPY . /app

# Start Ollama & Streamlit
CMD ollama serve & streamlit run app.py --server.port=8501 --server.address=0.0.0.0

