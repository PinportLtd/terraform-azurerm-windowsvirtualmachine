FROM pinport.azurecr.io/golangtesting:latest

# FROM russtym/pinport:latest

ARG BUILD_MODULE_NAME="windowsvm"
ENV MODULE_NAME=${BUILD_MODULE_NAME}

RUN apt-get update
RUN apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

RUN AZ_REPO=$(lsb_release -cs) && echo $AZ_REPO
RUN echo $AZ_REPO
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN cat /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update 
RUN apt-get install -y azure-cli 
     
#RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash -y
# Set work directory.

COPY . /go/src/${MODULE_NAME}
WORKDIR /go/src/${MODULE_NAME}

RUN chmod +x run-tests.sh

ENTRYPOINT [ "./run-tests.sh" ]