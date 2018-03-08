
FROM debian:jessie

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    motion \
    jq \
    cron \
    curl 
    
# Install the UV4L PPA
RUN curl -s http://www.linux-projects.org/listing/uv4l_repo/lrkey.asc | sudo apt-key add - 
RUN echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/ jessie main" /etc/apt/sources.list

# Install dependencies as well as the proper version of uv4l-webrtc
RUN apt-get update -q &&\
  apt-get install -yq \
    uv4l \
    uv4l-demos \
    uv4l-dummy \
    uv4l-mjpegstream \
    uv4l-raspicam \
    uv4l-raspicam-extras \
    uv4l-raspidisp \
    uv4l-server \
    uv4l-uvc \
    uv4l-xmpp-bridge \
    uv4l-xscreen \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
    
#RUN curl http://www.linux-projects.org/listing/uv4l_repo/lrkey.asc | apt-key add -
#RUN echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/ jessie main" > /etc/apt/sources.list.d/uv4l-wheezy.list

#RUN apt-get update &&  \
#    apt-get install -y \
#    uv4l
#    uv4l-raspicam \
#    uv4l-raspicam-extras

# Copy data
COPY run.sh /
COPY motion.conf /etc/motion/motion_template.conf
COPY camera_template.conf /etc/motion/
COPY crontab /etc/motion/crontab

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
