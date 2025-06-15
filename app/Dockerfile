
# Use a multi-stage build to reduce image size
 FROM node:23-alpine AS builder
 WORKDIR /app
 COPY package.json yarn.lock ./
 RUN yarn install 

 # production stage
FROM node:23-alpine AS production
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 3000
CMD ["yarn", "start"]