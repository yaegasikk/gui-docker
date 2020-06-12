sudo docker build -t amc2:latest .
sudo  docker run -p 8888:8888 --gpus all --rm  -v $(pwd):/user/local -it amc2:latest  /bin/bash
