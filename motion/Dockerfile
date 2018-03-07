
FROM debian:jessie

RUN apt-get update && apt-get install -q -y --no-install-recommends \
    motion \
    jq

# Copy data
COPY run.sh /
COPY motion.conf /etc/motion/motion_template.conf
COPY camera_template.conf /etc/motion/

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
