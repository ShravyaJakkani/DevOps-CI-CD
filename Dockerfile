FROM node:24-bookworm-slim

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies inside container
RUN npm install

# Copy source code
COPY . .

EXPOSE 8080

CMD ["npm", "start"]
