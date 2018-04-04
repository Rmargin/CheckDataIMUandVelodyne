#!/bin/bash
# Check: imu data and lidar data
# Time: 2018年04月04日08:49:03
# Author: wangrz 
# get where I am
MY_PATH=$(readlink -f  $(dirname $0))

# what type of terminal
OPTION_WORKING_DIR='--working-directory'

#disoplay szie post windows
OPTION_CORE_GEOMETRY='--geometry=50x10+0+0'
OPTION_IMU_GEOMETRY_NOT_MOVE='--geometry=80x30+0+0'
OPTION_IMU_GEOMETRY='--geometry=80x30+0+550'
OPTION_VELODYNE_GEOMETRY='--geometry=80x30+1300+550'
OPTION_RM_GEOMETRY='--geometry=50x10+500+0'
OPTION_RECORD_DATA_GEOMETRY='--geometry=50x30+650+250'
OPTION_COMMAND='--command'


MASTER_DISPLAY_OPTION="${OPTION_CORE_GEOMETRY} ${OPTION_TITLE}\=\"roscore\""

if [ $(which gnome-terminal) ]; then
    TERMINAL=gnome-terminal
    GNOME_VERSION=$(gnome-terminal --version | cut -d '.' -f  2)
    if [ ${GNOME_VERSION} -ge 14 ]; then
	MASTER_DISPLAY_OPTION=''
	RUNMGR_DISPLAY_OPTION=''
    fi
elif [ $(which mate-terminal) ]; then
    TERMINAL=mate-terminal
elif [ $(which xfce4-terminal) ]; then
    TERMINAL=xfce4-terminal
elif [ $(which lxterminal) ]; then
    TERMINAL=lxterminal
elif [ $(which konsole) ]; then
    TERMINAL=konsole
    OPTION_WORKING_DIR='--workdir'
    OPTION_CORE_GEOMETRY=''
    OPTION_RM_GEOMETRY=''
    OPTION_PM_GEOMETRY=''
    OPTION_COMMAND='-e'
    OPTION_TITLE='-T'
fi

echo "---HAHA Check Data Terminal Wangrz---"

# boot program
# display option set roscore
# ${TERMINAL} ${MASTER_DISPLAY_OPTION} ${OPTION_WORKING_DIR}=${MY_PATH} ${OPTION_COMMAND}="bash -c 'source ./devel_isolated/setup.bash;roslaunch velodyne_pointcloud 32e_points.launch'"&
# ${TERMINAL} ${OPTION_IMU_GEOMETRY_NOT_MOVE} ${OPTION_WORKING_DIR}=${MY_PATH} ${OPTION_COMMAND}="bash -c 'source ./devel_isolated/setup.bash;rosrun ros_imu_stim300 driver_cnu.py'"&
${TERMINAL} ${OPTION_IMU_GEOMETRY_NOT_MOVE} ${OPTION_WORKING_DIR}=${MY_PATH} ${OPTION_COMMAND}="bash -c 'source ./devel_isolated/setup.bash;roslaunch cartographer_ros run_velodyne32_imu.launch'"&
#delay time 2s
sleep 2s
#${TERMINAL} ${MASTER_DISPLAY_OPTION} ${OPTION_WORKING_DIR}=${MY_PATH} ${OPTION_COMMAND}="bash -c 'source ./devel_isolated/setup.bash; roscore'"&
${TERMINAL} ${OPTION_VELODYNE_GEOMETRY} ${OPTION_WORKING_DIR}=${MY_PATH} ${OPTION_COMMAND}="bash -c 'rostopic echo /velodyne_points'"&
${TERMINAL} ${OPTION_IMU_GEOMETRY} ${OPTION_WORKING_DIR}=${MY_PATH} ${OPTION_COMMAND}="bash -c 'rostopic echo /imu'"&
