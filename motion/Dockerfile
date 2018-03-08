
FROM debian:jessie

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    motion \
    jq \
    cron \
    wget
    
RUN wget http://www.linux-projects.org/listing/uv4l_repo/lrkey.asc
RUN apt-key add lrkey.asc

COPY /etc/apt/sources.list /share/motion/sources1.list
RUN echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/ jessie main" > /etc/apt/sources.list
COPY /etc/apt/sources.list /share/motion/sources2.list

RUN apt-get -y -q install  -q -y --no-install-recommends uv4l uv4l-raspicam uv4l-raspicam-extras

# Copy data
COPY run.sh /
COPY motion.conf /etc/motion/motion_template.conf
COPY camera_template.conf /etc/motion/
COPY crontab /etc/motion/crontab

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
