# Pull the base image with given version.
<<<<<<< HEAD
ARG BUILD_TERRAFORM_VERSION="0.13.0"
=======
ARG BUILD_TERRAFORM_VERSION="0.13.5"
>>>>>>> 0f607dbc9d08528bb16a48fc9dc8831aa4a92f5c
FROM mcr.microsoft.com/terraform-test:${BUILD_TERRAFORM_VERSION}

ARG MODULE_NAME="terraform-azurerm-postgresql"

# Declare default build configurations for terraform.
ARG BUILD_ARM_SUBSCRIPTION_ID=""
ARG BUILD_ARM_CLIENT_ID=""
ARG BUILD_ARM_CLIENT_SECRET=""
ARG BUILD_ARM_TENANT_ID=""
ARG BUILD_ARM_TEST_LOCATION="WestEurope"
ARG BUILD_ARM_TEST_LOCATION_ALT="WestUS"

# Set environment variables for terraform runtime.
ENV ARM_SUBSCRIPTION_ID=${BUILD_ARM_SUBSCRIPTION_ID}
ENV ARM_CLIENT_ID=${BUILD_ARM_CLIENT_ID}
ENV ARM_CLIENT_SECRET=${BUILD_ARM_CLIENT_SECRET}
ENV ARM_TENANT_ID=${BUILD_ARM_TENANT_ID}
ENV ARM_TEST_LOCATION=${BUILD_ARM_TEST_LOCATION}
ENV ARM_TEST_LOCATION_ALT=${BUILD_ARM_TEST_LOCATION_ALT}

# Set work directory.
RUN test -d /go     || mkdir /go
RUN test -d /go/bin || mkdir /go/bin
RUN test -d /go/src || mkdir /go/src
RUN mkdir /go/src/${MODULE_NAME}
COPY . /go/src/${MODULE_NAME}
WORKDIR /go/src/${MODULE_NAME}

# Install dep.
ENV GOPATH /go
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH
RUN go get github.com/katbyte/terrafmt
RUN /bin/bash -c "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"

RUN ["bundle", "install", "--gemfile", "./Gemfile"]