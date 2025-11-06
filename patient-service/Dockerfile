# ❌ CURRENT (EOL)
# FROM node:18-alpine3.18

# ✅ FIXED (Latest stable)
FROM node:18-alpine3.20

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3001

USER node

CMD [ "node", "patient-service.js" ]