FROM node
MAINTAINER Federico Minzoni, fminzoni@enter.it

# Work around https://github.com/dotnet/cli/issues/1582 until Docker releases a
# fix (https://github.com/docker/docker/issues/20818). This workaround allows
# the container to be run with the default seccomp Docker settings by avoiding
# the restart_syscall made by LTTng which causes a failed assertion.
ENV LTTNG_UST_REGISTER_TIMEOUT 0

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        clang-3.5 \
        libc6 \
        libcurl3 \
        libgcc1 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libtinfo5 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_CORE_SDK_VERSION 1.0.0-preview1-002702
RUN curl -SL https://dotnetcli.blob.core.windows.net/dotnet/beta/Binaries/$DOTNET_CORE_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_CORE_SDK_VERSION.tar.gz --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Create app directory
RUN mkdir -p /usr/src/app/server

# Install node dependencies
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install --no-optional

# Install dotnet dependencies
WORKDIR /usr/src/app/server
COPY server/project.json /usr/src/app/server/
RUN ["dotnet","restore"]

# Bundle app source
COPY . /usr/src/app/

EXPOSE 5000
CMD ["sh", "../start.sh"]
