# CIT-24-01-0565
Assignment 1 - Docker WordPress Application

Student Registration Number - CIT-24-01-0565
Name: P.D.D.S. Dasanayaka


## About this project

This assignment is about deploying a WordPress application using Docker containers .
The application uses two containers.

- WordPress
- MySQL

WordPress and MySQL communicate using a Docker bridge network. A docker volume is used to save the database , so that the data is not lost when the container are stopped.

## Files in this project

- prepare-app.sh
- start-app.sh
- stop-app.sh
- remove-app.sh
- docker-compose.yaml
- README.md

## Docker Network

Network Name
wordpress-network

This network allow the WordPress container and MySQL container to communicate with each other.


## Docker Volume

Volume Name
wordpress-data

This volume stores the MySQL database files. Because of this, the data remains even after stopping the containers.


## Containers

### WordPress Container

Container Name
wordpress-app
Image
wordpress:latest
Port Mapping
5000:80


### MySQL Container

Container Name
wordpress-db
Image
mysql:8.0

Database Settings


MYSQL_ROOT_PASSWORD=root123
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wp123


## How to prepare the application

Run

```bash
./prepare-app.sh
```

This script

- Creates the Docker network
- Creates the Docker volume
- Downloads the required Docker images


## How to start the application

Run

```bash
./start-app.sh

This script starts the MySQL container first. After MySQL is ready, it starts the WordPress container.
After that, open

http://localhost:5000

to access the application.


## How to stop the application

Run

```bash
./stop-app.sh

This script stops both containers but keeps the data.


## How to remove the application

Run

```bash
./remove-app.sh


This script removes

- WordPress container
- MySQL container
- Docker network
- Docker volume
- Downloaded Docker images


## Docker Compose

This project also includes a docker - compose.yaml file.
To start the application using Docker Compose;

```bash
docker compose up -d

To stop and remove everything

```bash
docker compose down -v --rmi all


## Project Structure


assignment1/
│
├── prepare-app.sh
├── start-app.sh
├── stop-app.sh
├── remove-app.sh
├── docker-compose.yaml
├── README.md
└── screenshots/


## Example

```bash
./prepare-app.sh

./start-app.sh

Open browser;

http://localhost:5000

./stop-app.sh
./remove-app.sh

## Notes
This project was tested on Ubuntu using Docker. The application runs successfully , and the database is stored in a Docker volume for persistence.
