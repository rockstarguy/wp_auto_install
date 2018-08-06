# HOW TO START

1. Build docker image
  ```
  docker build -t <docker_name> .
  ```
2. Docker run
  ```
  docker run --name wordpress -v -p 80:80 -d <docker_name>
  ```
