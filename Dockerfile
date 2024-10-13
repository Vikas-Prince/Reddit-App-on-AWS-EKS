# Stage 1: Build
FROM node:19-alpine AS builder

WORKDIR /reddit-app

# Copy package.json and package-lock.json for caching
COPY package*.json ./

# install required dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Production
FROM node:19-alpine AS runner

WORKDIR /reddit-app

# Copy built application from the builder stage
COPY --from=builder /reddit-app ./

# Expose port and start the application in production mode
EXPOSE 3000

# start the application
CMD ["npm", "start"]



