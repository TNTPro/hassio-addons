
FROM debian:jessie

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    motion \
    jq \
    cat \
    cron
#    curl 

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
# Use the crontab file
RUN crontab /etc/motion/crontab
# Start cron
RUN cron

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
