#!/bin/bash

# Set up the s3fs password file
echo $ACCESS_KEY_ID:$SECRET_ACCESS_KEY > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

# Mount the S3 bucket to the /minecraft directory
s3fs $BUCKET_NAME /minecraft -o allow_other

# Change the working directory to /minecraft
cd /minecraft
# eula.txt eula=true
echo "eula=true" > eula.txt
# Try running the Minecraft server
java -Xmx1024M -Xms1024M -jar server.jar nogui

# If the server failed to start, download the server and try again
if [ $? -ne 0 ]; then
    # Download the Minecraft server from the new URL
    curl -O https://piston-data.mojang.com/v1/objects/145ff0858209bcfc164859ba735d4199aafa1eea/server.jar
    # Run the Minecraft server
    java -Xmx1024M -Xms1024M -jar server.jar nogui
fi