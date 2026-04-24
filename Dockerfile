# -------------------
# Build Stage
# -------------------
FROM node:20-alpine AS builder

WORKDIR /app

COPY app/package*.json ./
RUN npm install

COPY app/ .
RUN npm run build


# -------------------
# Production Stage
# -------------------
FROM nginx:alpine

# Create a Non-Root User and Group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy Custom Nginx Config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built app
COPY --from=builder /app/dist /usr/share/nginx/html

# Fix File Permissions for the Non-Root User
RUN chown -R appuser:appgroup /usr/share/nginx/html \
    /var/cache/nginx \
    /var/run \
    /etc/nginx

# Switch User
USER appuser

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]