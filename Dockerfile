# Use an official Java runtime as a parent image
FROM amazoncorretto:22-alpine

# Install necessary packages
RUN apk add --no-cache fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git bash

# Download and install gcsfuse
RUN wget -qO- https://github.com/GoogleCloudPlatform/gcsfuse/releases/download/v0.35.1/gcsfuse-0.35.1-linux-amd64.tar.gz | tar xvz -C /usr/local/bin


# Clone s3fs repo and build it
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git \
    && cd s3fs-fuse \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install

# Set the working directory in the container to root
WORKDIR /

# Add the entrypoint script
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]