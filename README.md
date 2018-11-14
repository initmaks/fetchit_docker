## Docker container with pure Ubuntu 14.04 + ROS Indigo + Fetch Gazebo setup + VNC & openbox

This repository contains a Dockerfile for building ROS and Fetch packages on top of pure Ubuntu 14.04 docker image (with openbox window manager), which runs in a headless mode, and is viewed through the vnc.

## Building manually

To build manually, pull the repo:

```bash
git pull https://github.com/mksmsrkn/fetchit_docker.git
cd fetchit_docker
docker build -t fetchit_docker .
```

Building was tested on Ubuntu 18.04 Docker hosts.

## Running the image

To run the container enter:

```bash
docker run -d --name fetchit -p 5900:5900 fetchit_docker
```

## Connecting

You can use any VNC viewer of your choice to connect to the image.

VNC address: `localhost` OR `0.0.0.0` OR `127.0.0.1` (other of these would work)

VNC port: `5900` 
(if you prefer to use another port replace the first -p value when running docker run `-p $PORT:5900`)

After connecting you will see a black screen, you can make a right click to see the dropdown window managep menu, where you can open Terminal emulator (which is a Terminator by default).

## GQCNN Demo
1. Build the image with "docker build -t fetchit_docker_gqcnn ."
2. Download the pretrained network (from [URL](https://berkeley.app.box.com/s/szbchyt3tou9e4ct6dz8c5v99vhx0s84/folder/27403942113)) to `model/`
3. Run the container with `docker run -d -p 5900:5900 -v $(pwd)/model:/root/catkin_ws/src/gqcnn/models fetchit_docker_gqcnn`
4. Connect with VNC on localhost:5900 (might have to wait a few minutes)
5. Run `./setup.sh` to fix the yaml config file
6. Within the container you got to source the catkin_ws (`cd catkin_ws/ && source devel/setup.bash`)
7. Run demo from `catkin_ws/src/gqcnn` with `python examples/policy.py --config_filename cfg/examples/policy.yaml`

## Gazebo world package
1. Make sure you clone `https://github.com/mksmsrkn/fetchit_world.git` into a parent directory.
2. Follow the [https://github.com/mksmsrkn/fetchit_world/blob/master/README.md](https://github.com/mksmsrkn/fetchit_world/blob/master/README.md)

## Remarks
You can follow the steps from the Gazebo website now to run the simulator - [http://docs.fetchrobotics.com/gazebo.html#starting-the-simulator](http://docs.fetchrobotics.com/gazebo.html#starting-the-simulator).
