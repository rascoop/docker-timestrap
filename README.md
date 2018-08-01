# docker-timestrap

Dockerized version of self-hosted time sheet software Timestrap ( https://github.com/overshard/timestrap )

### Running

Create a "timestrap-database" directory which will hold the data and run the Docker image:

```sh
$ mkdir timestrap-database
$ docker run -d -v ./timestrap-database/:/timestrap/database/ -p 8000:8000 rascoop/timestrap:latest
```
Wait a minute for server to start and go to **http://localhost:8000** . Default login is username **admin** and password **admin**.

### Building Docker image

Instructions for building inside Dockerfile


### License
MIT
