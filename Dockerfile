# ==========================================
# Stage 1: Build the Application
# ==========================================
FROM node:20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy only the package files first to leverage Docker cache
COPY package.json yarn.lock ./

# Install dependencies using Yarn
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the application (this creates the build/ or dist/ folder)
RUN yarn build

# ==========================================
# Stage 2: Serve with Nginx
# ==========================================
FROM docker.io/nginxinc/nginx-unprivileged:alpine

# Copy your custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy ONLY the compiled assets from the 'builder' stage
# (Adjust /app/build to /app/dist if your app outputs a dist folder)
COPY --from=builder /app/build /usr/share/nginx/html

# Expose the unprivileged port
EXPOSE 8080