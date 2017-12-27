# Docker Image to Survey Path and Convert Videos to Web Format

installation:

Create a docker container:

docker run -it --name ChangeName mwaeckerlin/video-converter bash


Upload Video:

1. Upload from video hosted on your local machine

    docker cp SRC_PATH CONTAINER:DEST_PATH

2. Upload from video from url

    First install curl:
        apt-get update && apt-get install curl

    curl -O URL
    

**** MAKE SURE YOU PLACE THE VIDEO IN /DATA DIRECTORY ****
If /data doesn't exists, then create(mkdir -p /data) it


Run start script:
    cd /
    ./start.sh


Result:

    You should get a list of web friendly versions(mp4, webm, ogv) of your video.

