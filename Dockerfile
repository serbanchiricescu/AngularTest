FROM node:14.4-alpine as builder

# Change the dir to the one where we build the angular app
WORKDIR /app-ui

# Copy the package.json to install dependencies
COPY package.json package-lock.json ./

# Install the dependencies and make the folder
RUN npm install

# Copy source files
COPY . .

# Build the project
# Base href is the url location in the browser, deploy url is the url at
# which the asset files are served (js, css, etc)
RUN npm run ng build -- --base-href /appui/ --deploy-url /appui/ --prod


FROM nginx:alpine

#!/bin/sh

COPY nginx.conf /etc/nginx/nginx.conf

# Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from the stage 1
COPY --from=builder /app-ui/dist/AngularTest /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]