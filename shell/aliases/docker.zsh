alias dr="docker"
dsa() { docker stop `docker ps --no-trunc -aq` }
dra() { docker rm `docker ps --no-trunc -aq` }