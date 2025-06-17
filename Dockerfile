# ---------- Build Stage ----------
FROM node:20-alpine AS build
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:alpine

# Copy built files from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Replace default Nginx config with custom one
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose container port 80 (standard for Nginx)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
