#!/bin/bash
if [ ! -d ./work/px4 ] ; then
    cd ./work
    git clone git@github.com:PX4/PX4-Autopilot px4
    cd px4
    git tag v1.14.0-beta2
    cd ../..
fi

if [ ! -d ./work/ros2_ws/src ] ; then
    mkdir -p ./work/ros2_ws/src
    cd work/ros2_ws/src
    git clone git@github.com:PX4/px4_msgs.git
    git clone git@github.com:Jaeyoung-Lim/px4-offboard.git
    git clone -b humble git@github.com:gazebosim/ros_gz.git
fi

