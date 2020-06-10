sudo docker build -t amc:latest .
sudo  docker run  --gpus all --rm  -v $(pwd):/user/local -it amc:latest  /bin/bash
