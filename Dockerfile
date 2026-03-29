# Multi-stage build
FROM node:18-alpine AS builder

WORKDIR /app
COPY server/package*.json ./
RUN npm ci --only=production

# Final stage
FROM node:18-alpine

WORKDIR /app

# Copy dependencies from builder
COPY --from=builder /app/node_modules ./node_modules
COPY server/package*.json ./
COPY server/server.js ./
COPY index.html ./

# Create data directory for persistent storage
RUN mkdir -p /app/data

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => {if(r.statusCode!==200)throw new Error(r.statusCode)})"

# Start server
CMD ["node", "server.js"]
