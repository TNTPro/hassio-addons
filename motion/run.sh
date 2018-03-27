#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

CONFIG=$(jq --raw-output ".config" $CONFIG_PATH)
UPDATECRON=$(jq --raw-output ".updatecron" $CONFIG_PATH)

DEVICE_COUNT=$(jq --raw-output ".videodevices | length" $CONFIG_PATH)

if [ ! -f "$CONFIG" ]; then	
	echo "Copy motion template"
	cp /etc/motion/motion_template.conf /share/motion/motion.conf
	cp /delete_images.sh /share/motion/delete_images.sh
fi

touch /share/motion/motion-cron

for (( i=0; i < "$DEVICE_COUNT"; i++ )); do
	echo "Start config $i"
	
	if [ ! -f "$CONFIG" ]; then	
		echo "Copy camera template"
		cp /etc/motion/camera_template.conf /share/motion/camera$i.conf

		echo "Get config values"
		VIDEODEVICE=$(jq --raw-output ".videodevices[$i].device" $CONFIG_PATH)
		#echo $VIDEODEVICE
		INPUT=$(jq --raw-output ".videodevices[$i].input" $CONFIG_PATH)
		#echo $INPUT
		WIDTH=$(jq --raw-output ".videodevices[$i].width" $CONFIG_PATH)
		#echo $WIDTH
		HEIGHT=$(jq --raw-output ".videodevices[$i].height" $CONFIG_PATH)
		#echo $HEIGHT
		FRAMERATE=$(jq --raw-output ".videodevices[$i].framerate" $CONFIG_PATH)
		TEXTRIGHT=$(jq --raw-output ".videodevices[$i].text_right" $CONFIG_PATH)
		TARGETDIR=$(jq --raw-output ".videodevices[$i].target_dir" $CONFIG_PATH)
		#echo $TARGETDIR
		SNAPSHOTINTERVAL=$(jq --raw-output ".videodevices[$i].snapshot_interval" $CONFIG_PATH) 
		SNAPSHOTNAME=$(jq --raw-output ".videodevices[$i].snapshot_name" $CONFIG_PATH) 
		PICTUREOUTPUT=$(jq --raw-output ".videodevices[$i].picture_output" $CONFIG_PATH)
		PICTURENAME=$(jq --raw-output ".videodevices[$i].picture_name" $CONFIG_PATH)
		WEBCONTROLLOCAL=$(jq --raw-output ".videodevices[$i].webcontrol_local" $CONFIG_PATH)
		WEBCONTROLHTML=$(jq --raw-output ".videodevices[$i].webcontrol_html" $CONFIG_PATH)	
		
		echo "Fill config with values"
		sed -i "s|%%VIDEODEVICE%%|$VIDEODEVICE|g" /share/motion/camera$i.conf
		sed -i "s|%%INPUT%%|$INPUT|g" /share/motion/camera$i.conf
		sed -i "s|%%WIDTH%%|$WIDTH|g" /share/motion/camera$i.conf
		sed -i "s|%%HEIGHT%%|$HEIGHT|g" /share/motion/camera$i.conf
		sed -i "s|%%FRAMERATE%%|$FRAMERATE|g" /share/motion/camera$i.conf
		sed -i "s|%%TEXTRIGHT%%|$TEXTRIGHT|g" /share/motion/camera$i.conf
		sed -i "s|%%TARGETDIR%%|$TARGETDIR|g" /share/motion/camera$i.conf
		sed -i "s|%%SNAPSHOTINTERVAL%%|$SNAPSHOTINTERVAL|g" /share/motion/camera$i.conf
		sed -i "s|%%SNAPSHOTNAME%%|$SNAPSHOTNAME|g" /share/motion/camera$i.conf
		sed -i "s|%%PICTUREOUTPUT%%|$PICTUREOUTPUT|g" /share/motion/camera$i.conf
		sed -i "s|%%PICTURENAME%%|$PICTURENAME|g" /share/motion/camera$i.conf
		sed -i "s|%%WEBCONTROLLOCAL%%|$WEBCONTROLLOCAL|g" /share/motion/camera$i.conf
		sed -i "s|%%WEBCONTROLHTML%%|$WEBCONTROLHTML|g" /share/motion/camera$i.conf		
	
		echo "thread /share/motion/camera$i.conf" >> /share/motion/motion.conf
		#cp /etc/motion/camera$i.conf /share/motion/camera$i.conf
	
	fi
	
	if [ "$UPDATECRON" == "true" ]; then
		#echo /etc/motion/crontab >> /share/motion/motion-cron
		#cat /etc/motion/crontab >> /share/motion/motion-cron
		
		
		REMOVECMD  = "%%PLACEHOLDER%% \n rm -rf "+$TARGETDIR+ "/*.jpg"
		
		sed -i "s|%%PLACEHOLDER%%|$REMOVECMD|g" /share/motion/delete_images.sh
	fi	
	
	echo "End config $i"
done
if [ ! -f "$CONFIG" ]; then
	CONFIG=/etc/motion/motion.conf
fi

cp /share/motion/motion.conf $CONFIG 

cp /share/motion/delete_images.sh /delete_images.sh

chmod a+x /share/motion/delete_images.sh

echo "[Info] Run delete_images"
/share/motion/delete_images.sh &

echo "[Info] Show connected usb devices"
ls -al /dev/video*


# start server
#motion -c $CONFIG
