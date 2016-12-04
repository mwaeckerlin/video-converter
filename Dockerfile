FROM ubuntu
MAINTAINER mwaeckerlin

ENV SRC '/data'
ENV DST '/video'
ENV "ogg webm mp4"
ENV FLAGS_ogg "-c:v libtheora -c:a libvorbis -q:v 6 -q:a 5"
ENV FLAGS_webm "-vcodec libvpx -acodec libvorbis -f webm -aq 5 -ac 2 -qmax 25 -threads 2"
ENV FLAGS_mp4 "-vcodec libx264 -acodec aac -strict experimental -crf 19"

RUN apt-get update
RUN apt-get install -y libav-tools
ADD start.sh /start.sh
CMD /start.sh

VOLUME /video