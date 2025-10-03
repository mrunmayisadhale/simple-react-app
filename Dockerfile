# STAGE 1: The "builder" stage
# This stage uses a Node.js environment to build our React app.
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package files first to leverage Docker's layer caching.
# This step only re-runs if package.json changes.
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application for production
# This creates the optimized static files in the 'dist' folder.
RUN npm run build

# STAGE 2: The "final" stage
# This stage uses a lightweight Nginx server to serve the static files.
FROM nginx:stable-alpine

# Copy the built static files from the 'builder' stage
# into the directory where Nginx serves web content.
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx listens on port 80 by default, so we just expose it.
EXPOSE 80

# The command to start Nginx when the container runs.
CMD ["nginx", "-g", "daemon off;"]