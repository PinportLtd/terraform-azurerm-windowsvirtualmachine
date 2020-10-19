FROM pinport.azurecr.io/golangtesting:latest

ARG BUILD_MODULE_NAME="windowsvm"
ENV MODULE_NAME=${BUILD_MODULE_NAME}

# Set work directory.

COPY . /go/src/${MODULE_NAME}
WORKDIR /go/src/${MODULE_NAME}

RUN chmod +x run-tests.sh

ENTRYPOINT [ "./run-tests.sh" ]