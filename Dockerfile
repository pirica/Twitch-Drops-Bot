FROM node:current-bullseye

# Install Chromium
RUN apt-get update && apt-get install chromium -y

# Copy required files
WORKDIR /app
COPY ./src ./src
COPY package*.json ./
COPY tsconfig.json ./

# Don't download the bundled Chromium with Puppeteer (It doesn't have the required video codecs to play Twitch video streams)
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Install dependencies
RUN npm install

# Compile the app
RUN npm run compile

WORKDIR /app/data

ENTRYPOINT ["node", "--unhandled-rejections=strict", "/app/dist/index.js", \
     "--config", \
     "config.json", \
     "--browser", "chromium", \
     "--browser-args=--no-sandbox", \
     "--headless-login"]
