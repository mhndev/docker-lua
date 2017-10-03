FROM debian:jessie

MAINTAINER Majid Abdolhosseini <majid@mhndev.com>

ENV lua_verision  5.3.4
ENV luarocks_version 2.4.1

# install essential packages for building other packages

RUN apt-get update && apt-get install -y \
		curl \
		wget \
		build-essential \
		make \
		mingw-w64 \
		libreadline-dev \
		ca-certificates \
		unzip \
--no-install-recommends && rm -r /var/lib/apt/lists/*


# build lua

RUN \
wget http://www.lua.org/ftp/lua-${lua_verision}.tar.gz && \
tar xf lua-${lua_verision}.tar.gz && \
cd lua-${lua_verision} && \
#./configure --prefix=/opt/apps/lua/${lua_verision} && \
make linux && \

ln -s /lua-${lua_verision}/src/lua /usr/bin/lua


# build luarocks

RUN \
wget https://luarocks.org/releases/luarocks-${luarocks_version}.tar.gz && \
tar zxpf luarocks-${luarocks_version}.tar.gz  && \
cd luarocks-${luarocks_version}  && \
./configure --with-lua-include=/lua-${lua_verision}/src/ ; make bootstrap   && \
luarocks install luasocket

# Remove unneccessary packages (packages just needed for building image)

RUN apt-get remove --purge -y \
    curl \
    wget \
    make \
    build-essential \
    libreadline-dev \
    mingw-w64 && \

    apt-get autoremove -y


CMD ["lua", "-v"]
