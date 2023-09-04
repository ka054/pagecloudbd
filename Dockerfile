FROM python:3.9-slim

# Creating Application Source Code Directory
RUN mkdir -p /usr/app

# Setting Home Directory for containers
WORKDIR /usr/app

# Installing python dependencies
COPY requirements.txt /usr/app/

RUN pip install --no-cache-dir -r requirements.txt

# Copying src code to Container
COPY . /usr/app

# Exposing Ports
EXPOSE 8080

# Running Python Application
CMD gunicorn -b :8080 -c gunicorn.conf.py main:app
