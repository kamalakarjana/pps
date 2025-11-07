# ✅ FIXED (Latest stable)
FROM node:18-alpine3.20

# Install curl for health checks
RUN apk add --no-cache curl

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3001

USER node

CMD [ "node", "appointment-service.js" ]