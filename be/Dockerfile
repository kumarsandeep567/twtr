#########
# FINAL #
#########

# Base image
FROM python:3.9-slim-buster

# Set working directory
WORKDIR /app

# Update underlying packages
RUN apt-get update

# Copy the Backend source code to /app
COPY ./ /app

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Create a non-root user and run commands using 
# the non-root user
RUN adduser --disabled-password dummyuser
USER dummyuser

# Set Flask to run in development mode
# To run Flask in production mode, 
# set FLASK_ENV=production
ENV FLASK_ENV {$FLASK_ENV}

# Set the MongoDB url
ENV DATABASE_URL {$DATABASE_URL}

# Remember to map external port to the container's 
# port 5000
EXPOSE 5000

# Start Gunicorn server with 3 threads listening 
# on port 5000 and set target application to 
# wsgi.py file

# There seems to be some issues with gunicorn 
# not being visible in the PATH variable
# Try running the app via python3
CMD ["python3", "twtr.py"]