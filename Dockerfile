# ---- Runtime stage ----
# Using the unprivileged Alpine image for an excellent production security footprint
FROM nginxinc/nginx-unprivileged:alpine

# 1. Remove the standard boilerplate default configuration
RUN rm -f /etc/nginx/conf.d/default.conf

# 2. Copy your custom MAIN nginx.conf to its correct global location
# This is the file containing your global settings (like 'pid /tmp/nginx.pid;')
COPY nginx.conf /etc/nginx/nginx.conf

# # 3. Copy your clean server-block configuration to conf.d
# # This file handles routing and has NO pid directive, preventing context crashes
# COPY clean_default.conf /etc/nginx/conf.d/default.conf  

# 4. Copy your PRE-BUILT assets directly from your local host machine
# (Change "build" to "dist" if your local build script outputs to a dist/ folder)
COPY app/build /usr/share/nginx/html

EXPOSE 8080

# Improved Healthcheck: Use the -T option to specify timeout
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:8080/health || exit 1

    
# Run as unprivileged user (Nginx unprivileged image standard)
USER 101
CMD ["nginx", "-g", "daemon off;"]