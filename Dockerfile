# Use official Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copying package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# For Expose port
EXPOSE 3000

# To Start the application
CMD ["node", "index.js"]
