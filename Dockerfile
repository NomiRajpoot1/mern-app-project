# Set the base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /opt/mern-app

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    git \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs mongodb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create data directories for MongoDB
RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db

# Clone the application files into the container
ADD https://github.com/NomiRajpoot1/mern-app-project.git .

# Install dependencies for the entire application
RUN npm install

# Build the frontend
WORKDIR /opt/mern-app/frontend
RUN npm install
RUN npm run build

# Switch to the backend directory
WORKDIR /opt/mern-app

EXPOSE 5000

# Start MongoDB and the Node.js application with pm2
CMD ["sh", "-c", "mongod --bind_ip_all --dbpath /data/db --logpath /var/log/mongodb/mongodb.log --fork && npm run server"]
