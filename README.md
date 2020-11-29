# bf3-vu-server
Still WIP! This is a VERY UNOPTIMIZED docker container for running a Battlefield 3 Venice Unleashead server.

Docker build command

  docker build -t greinet/bf3-vu-server .

Docker run command
  docker run --rm -v /home/agreiner/dockerData/gameserver/bf3/vu/instance/:/root/bf3/vu/instance -v /home/agreiner/dockerData/gameserver/bf3/gamedata/bf3:/root/bf3/gamedata/bf3 -p 12321:8080 -p 7948:7948/udp -p 25200:25200/udp -p 47200:47200 greinet/bf3-vu-server
