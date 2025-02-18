# Use Python 3.10 as the base image (already includes Python)
FROM python:3.10

# Set the working directory inside the container
WORKDIR /app

# Copy and install dependencies first (ensures layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 8501 for Streamlit
EXPOSE 8501

# Start the Ollama server and run the Streamlit app
CMD ollama serve & python -m streamlit run app.py --server.port=8501 --server.address=0.0.0.0
