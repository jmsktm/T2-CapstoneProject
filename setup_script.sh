#!/bin/bash

# Ref: https://gist.github.com/jmsktm/71e6b78d01b38ea93693fb5a0c72a4d7

#Setup base paths
WORKSPACE_PATH="/home/workspace/capstone_ws"
PROJECT_NAME="project"

# Setup the base repository
rm -rf $WORKSPACE_PATH
mkdir -p $WORKSPACE_PATH && cd $WORKSPACE_PATH
git clone https://github.com/jmsktm/T2-CapstoneProject.git $PROJECT_NAME
cd $PROJECT_NAME
git checkout --track origin/yolo

# Install some required packages etc.
apt update
apt install -y ros-kinetic-dbw-mkz-msgs
pip install --upgrade pip
apt -y install python-rosdep
apt -y install python-catkin-pkg

# Running this multiple times helped deal with the flakiness of catkin_make failures
pip install catkin-pkg-modules
pip install catkin-pkg-modules
pip install catkin-pkg-modules
pip install catkin-pkg-modules
pip install catkin-pkg-modules

pip install -r requirements.txt
apt update

cd ros
rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y
cd src

# Clone the darknet_ros repo recursively (to pull both darknet_ros and darknet)
# and patch the darknet_ros/darknet_ros/config/ros.yaml file to use the topic
# /image_color instead of /camera/rgb/image_raw (default) to get image from camera.
git clone --recursive https://github.com/leggedrobotics/darknet_ros.git
cd darknet_ros
git apply ../update_topic.patch
cd ../..

# Build and run the catkin project.
catkin_make
source devel/setup.bash
roslaunch launch/styx.launch