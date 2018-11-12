#!/bin/bash

sed -i "s/virtual_primesense/virtual/g" /root/catkin_ws/src/gqcnn/cfg/examples/policy.yaml
sed -i "s/\/home\/user\/data\/models\/GQ\-Image\-Wise/\/root\/catkin_ws\/src\/gqcnn\/models/g" /root/catkin_ws/src/gqcnn/cfg/examples/policy.yaml
