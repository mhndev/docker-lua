# lua Dockerfile

## Includes 

#### 1 ) lua
#### 2 ) luarocks (Lua package manager)

## Default lua version : 5.3.4
## Default luarocks version : 2.4.1


## get this image

you can execute following command to get this docker image :

```
docker pull mhndev/docker-lua
```

## About Dockerfile

if you look at dockerfile you can see that 
lua version and luarocks version are as environment variable
so you can simply change it to any version you want.

this package build from source , so you can any version which you need and,
you don't have to just select among your linux distribution available packages .


## Install lua modules (packages)

by running following command you can install lua plugin in container

```
docker-compose exec lua_server install-module <module-name>
```

for example for installing kong module :

```
docker-compose exec lua_server install-module kong
```

## Pre Installed lua modules

also in your dockerfile there is environment variable called "needed_modules"
you can list all needed modules for your lua runtime, so by running container from your image
all modules already are in container.
