FROM ubuntu:trusty

##### ROS Indigo ######
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' &&\
	apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 &&\
	apt-get update &&\
	apt-get install -y ros-indigo-desktop-full &&\
	rosdep init &&\
	rosdep update &&\
	apt-get install -y python-rosinstall

RUN echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
##### END : ROS Indigo ######

##### Fetch Gazebo ######
RUN apt-get update &&\
	apt-get install -y ros-indigo-fetch-gazebo-demo
##### END: Fetch Gazebo ######

##### SUBLIME TEXT + TERMINATOR #####
RUN apt-get update &&\ 
	apt-get install -y software-properties-common python-software-properties &&\
	add-apt-repository -y ppa:webupd8team/sublime-text-3 &&\
	apt-get update &&\ 
    apt-get install -y sublime-text &&\
    apt-get install -y terminator
##### END : SUBLIME TEXT + TERMINATOR #####

##### VNC + OPENBOX #####
# Install a VNC X-server, Frame buffer, and windows manager
RUN apt-get install -y x11vnc xvfb openbox obconf

# Finally, install wmctrl needed for bootstrap script
RUN apt-get install -y wmctrl 

# Copy scripts
COPY bootstrap.sh /
##### END : VNC + OPENBOX #####

CMD '/bootstrap.sh'