# Use the official Python image as the base image
FROM python:3.10.6

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all the files from the current directory to the container's working directory
COPY . .

# Expose port 8000 (the port Gunicorn will use)
EXPOSE 8000

# Command to run the application with Gunicorn
CMD ["gunicorn", "wsgi:app", "-b", "0.0.0.0:8000"]