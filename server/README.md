
npm install --os=linux --cpu=x64


# DOCKER BUILD
docker build --platform linux/amd64 -t lambda-node-docker .

# DOCKER RUN LOCALLY LAMBDA

docker run --platform linux/amd64 -p 9000:8080 lambda-node-docker