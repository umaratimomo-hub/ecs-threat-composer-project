# ==========================================
# Stage 1: Build the Application
# ==========================================
FROM node:20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy only the package files first to leverage Docker cache
COPY app/package.json app/yarn.lock ./

RUN yarn install --frozen-lockfile

COPY app/ ./

# Build the application
RUN yarn build

# ==========================================
# Stage 2: Serve with Nginx
# ==========================================
FROM docker.io/nginxinc/nginx-unprivileged:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy ONLY the compiled assets from the 'builder' stage
# (Adjust /app/build to /app/dist if app outputs a dist folder)
COPY --from=builder /app/build /usr/share/nginx/html

# Expose the unprivileged port
EXPOSE 8080