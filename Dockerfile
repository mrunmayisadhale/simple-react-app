# Example Dockerfile
FROM node:22-alpine AS build
WORKDIR /app

# install deps
COPY package*.json ./
RUN npm ci

# copy source & build
COPY . .
RUN npm run build

# (optional) serve the built files with a tiny web server
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
