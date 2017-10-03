FROM debian:jessie

MAINTAINER Majid Abdolhosseini <majid@mhndev.com>

ENV lua_verision  5.3.4
ENV luarocks_version 2.4.1
ENV needed_modules "kong lua-cjson"


# install essential packages for building other packages

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
		curl \
		wget \
		build-essential \
		make \
		gcc \
		mingw-w64 \
		libreadline-dev \
		ca-certificates \
		unzip \
		libssl-dev \
		git \
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
    wget \
    make \
    build-essential \
    libreadline-dev \
    ca-certificates \
    mingw-w64 && \

    apt-get autoremove -y

COPY ["./commands/*.sh", "/docker/bin/"]

RUN chmod a+x /docker/bin/*.sh \
    && ln -s /docker/bin/install-module.sh /usr/local/bin/install-module


# code which is running bellow
#
# if [ ! -z ${needed_modules} ] ;
#    then
#        for i in ${needed_modules}; do
#            luarocks install "$i";
#        done ;
#    else echo "no modules needed, so no module installed";
# fi

RUN if[[ ! -z ${needed_modules} ]] ; then for i in ${needed_modules}; do luarocks install $i; done ; else echo "no modules needed, so no module installed" ; fi

CMD ["run", "-v"]
