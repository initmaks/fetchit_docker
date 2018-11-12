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

#### Install GQ-CNN 
RUN apt-get update && \
	curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
	python get-pip.py && \
	pip install --upgrade pip && \
	rm get-pip.py

# Newer version of tornado incompatiple with 14.04
RUN pip install tornado==4.* numpy scipy matplotlib tensorflow opencv-python scikit-image scikit-learn pillow 
RUN mkdir -p /root/catkin_ws/src

SHELL ["/bin/bash", "-c"]	# Change to bash shell for ros stuff
RUN source /opt/ros/indigo/setup.bash && cd /root/catkin_ws && catkin_make

# Install Autolab_core (https://berkeleyautomation.github.io/autolab_core/install/install.html)
RUN pip install -U setuptools && cd /root/catkin_ws/src && git clone https://github.com/BerkeleyAutomation/autolab_core.git && \
	cd autolab_core && python setup.py install && \
	cd /root/catkin_ws/ && source /opt/ros/indigo/setup.bash && catkin_make && source devel/setup.bash

# Install Autolab_perception (https://berkeleyautomation.github.io/perception/install/install.html)
RUN cd /root/catkin_ws/src && git clone https://github.com/BerkeleyAutomation/perception.git && \
	cd perception/ && pip install -e . && \
	cd /root/catkin_ws/ && source /opt/ros/indigo/setup.bash && catkin_make

# Install GQ-CNN itself (https://berkeleyautomation.github.io/gqcnn/install/install.html#berkeleyautomation-packages)
RUN cd /root/catkin_ws/src && git clone https://github.com/BerkeleyAutomation/gqcnn.git && \
	cd /root/catkin_ws/src/gqcnn/ && pip install -r requirements.txt --ignore-installed && \
	cd /root/catkin_ws && source /opt/ros/indigo/setup.bash && catkin_make

COPY setup.sh /root/