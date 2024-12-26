aws ecr get-login-password --region eu-west-3 --profile  floiint| docker login --username AWS --password-stdin 392002456877.dkr.ecr.eu-west-3.amazonaws.com
docker build -t floiint-docker .
docker tag floiint-docker:latest 392002456877.dkr.ecr.eu-west-3.amazonaws.com/floiint-docker:latest
docker push 392002456877.dkr.ecr.eu-west-3.amazonaws.com/floiint-docker:latest 