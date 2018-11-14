#!/bin/bash
docker run --name fetchit \
		   -d \
		   -p 5900:5900 \
		   -v $(pwd)/model:/root/catkin_ws/src/gqcnn/models \
		   -v $(pwd)/../fetchit_world:/root/catkin_ws/src/fetchit_world \
		   mksmsrkn/fetchit_docker