# STAGE 1: The "builder" stage
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# STAGE 2: The "final" stage
FROM nginx:stable-alpine

# Copy the built static files from the 'builder' stage
COPY --from=builder /app/dist /usr/share/nginx/html

# --- THIS IS THE NEW LINE ---
# Copy our custom Nginx configuration to replace the default one.
COPY nginx.conf /etc/nginx/nginx.conf

# Nginx listens on port 80 by default, so we just expose it.
EXPOSE 80

# The command to start Nginx when the container runs.
CMD ["nginx", "-g", "daemon off;"]