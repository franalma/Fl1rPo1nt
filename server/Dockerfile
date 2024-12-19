FROM public.ecr.aws/lambda/nodejs:22

# WORKDIR /var/task
COPY src/ ${LAMBDA_TASK_ROOT}/src
COPY node_modules/ ${LAMBDA_TASK_ROOT}/node_modules
COPY package.json ${LAMBDA_TASK_ROOT}
COPY .env ${LAMBDA_TASK_ROOT}

RUN npm install --os=linux --cpu=x64 sharp

# Install AWS Lambda Runtime Interface Emulator (RIE)
# ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /aws-lambda-rie
# RUN chmod +x /aws-lambda-rie
# Set the entrypoint to the RIE
# ENTRYPOINT ["/aws-lambda-rie"]
# ENTRYPOINT ["node","src/handler_api"]

CMD ["src/handler_api.handler"]