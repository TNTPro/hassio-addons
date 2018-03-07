#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

CONFIG=$(jq --raw-output ".config" $CONFIG_PATH)

DEVICE_COUNT=$(jq --raw-output ".videodevices | length" $CONFIG_PATH)

for (( i=0; i < "$DEVICE_COUNT"; i++ )); do
	cp /etc/camera_template.conf /etc/camera$i.conf
	
	VIDEODEVICE=$(jq --raw-output ".videodevices[$i].device" $CONFIG_PATH)
	INPUT=$(jq --raw-output ".videodevices[$i].input" $CONFIG_PATH)
	WIDTH=$(jq --raw-output ".videodevices[$i].width" $CONFIG_PATH)
	HEIGHT=$(jq --raw-output ".videodevices[$i].height" $CONFIG_PATH)
	FRAMERATE=$(jq --raw-output ".videodevices[$i].framerate" $CONFIG_PATH)
	TEXTRIGHT=$(jq --raw-output ".videodevices[$i].text_right" $CONFIG_PATH)
	TARGETDIR=$(jq --raw-output ".videodevices[$i].target_dir" $CONFIG_PATH)
	SNAPSHOTINTERVAL=$(jq --raw-output ".videodevices[$i].snapshot_interval" $CONFIG_PATH) 
	SNAPSHOTNAME=$(jq --raw-output ".videodevices[$i].snapshot_name" $CONFIG_PATH) 
	PICTUREOUTPUT=$(jq --raw-output ".videodevices[$i].picture_output" $CONFIG_PATH)
	PICTURENAME=$(jq --raw-output ".videodevices[$i].picture_name" $CONFIG_PATH)
	WEBCONTROLLOCAL=$(jq --raw-output ".videodevices[$i].webcontrol_local" $CONFIG_PATH)
	WEBCONTROLHTML=$(jq --raw-output ".videodevices[$i].webcontrol_html" $CONFIG_PATH)
	
	if [ ! -f "$CONFIG" ]; then
		sed -i "s|%%VIDEODEVICE%%|$VIDEODEVICE|g" /etc/camera$i.conf
		sed -i "s|%%INPUT%%|$INPUT|g" /etc/camera$i.conf
		sed -i "s|%%WIDTH%%|$WIDTH|g" /etc/camera$i.conf
		sed -i "s|%%HEIGHT%%|$HEIGHT|g" /etc/camera$i.conf
		sed -i "s|%%FRAMERATE%%|$FRAMERATE|g" /etc/camera$i.conf
		sed -i "s|%%TEXTRIGHT%%|$TEXTRIGHT|g" /etc/camera$i.conf
		sed -i "s|%%TARGETDIR%%|$TARGETDIR|g" /etc/camera$i.conf
		sed -i "s|%%SNAPSHOTINTERVAL%%|$SNAPSHOTINTERVAL|g" /etc/camera$i.conf
		sed -i "s|%%SNAPSHOTNAME%%|$SNAPSHOTNAME|g" /etc/camera$i.conf
		sed -i "s|%%PICTUREOUTPUT%%|$PICTUREOUTPUT|g" /etc/camera$i.conf
		sed -i "s|%%PICTURENAME%%|$PICTURENAME|g" /etc/camera$i.conf
		sed -i "s|%%WEBCONTROLLOCAL%%|$WEBCONTROLLOCAL|g" /etc/camera$i.conf
		sed -i "s|%%WEBCONTROLHTML%%|$WEBCONTROLHTML|g" /etc/camera$i.conf
		CONFIG=/etc/motion.conf
	fi
done




echo "[Info] Show connected usb devices"
ls -al /dev/video*


# start server
motion -c $CONFIG
