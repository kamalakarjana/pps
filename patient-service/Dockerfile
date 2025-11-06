# ❌ CURRENT (VULNERABLE)
# FROM node:14-alpine

# ✅ FIXED VERSION
FROM node:18-alpine3.18

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3001

USER node

# ✅ FIX: Correct the startup file name
CMD [ "node", "appointment-service.js" ]