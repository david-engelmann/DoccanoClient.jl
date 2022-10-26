# [Choice] Julia Version, 1.7.2 is default 
ARG JULIA_VERSION="1.7.2"
FROM julia:$JULIA_VERSION
ENV JULIA_VERSION $JULIA_VERSION

# [Choice] Enviroment Type: "dev", "prod", "stage"
ARG ENV_TYPE="dev"
ENV ENV_TYPE $ENV_TYPE
RUN echo "Enviroment - $ENV_TYPE"

# [Choice] Project Version: 1, 1.01, latest
ARG PROJECT_VERSION=1
ENV PROJECT_VERSION $PROJECT_VERSION
RUN echo "Build Version: $PROJECT_VERSION"


ARG JULIA_THREADS=1
ENV JULIA_THREADS $JULIA_THREADS

# Add a Maintainer Label
LABEL maintainer="david-engelmann"
# Add a Department Label
LABEL department="product"

ARG TIMEZONE=America/New_York
ENV TIMEZONE $TIMEZONE
RUN set -xe; \
    apt update && apt upgrade -y; \
    ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime; \
    apt install -y tzdata; \
    dpkg-reconfigure --frontend noninteractive tzdata;

# OS Packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apt-utils gcc g++ openssh-server cmake build-essential gdb \
    gdbserver rsync vim locales git
RUN apt-get install -y bzip2 wget gnupg dirmngr apt-transport-https \
	tzdata ca-certificates openssh-server tmux && \
    apt-get clean

# Change to Project Base Folder
WORKDIR /workspaces/doccano_api

# the important parts of dockerfile
RUN julia -e 'using Pkg; Pkg.add("HTTP", preserve=PRESERVE_DIRECT);'


RUN julia -e 'using Pkg; Pkg.add("URIs", preserve=PRESERVE_DIRECT);'
RUN julia -e 'using Pkg; Pkg.add("JSON3", preserve=PRESERVE_DIRECT);'
RUN julia -e 'using Pkg; Pkg.add("JSON", preserve=PRESERVE_DIRECT);'
RUN julia -e 'using Pkg; Pkg.add("Statistics", preserve=PRESERVE_DIRECT);'

RUN julia -e 'using Pkg; Pkg.add("InteractiveUtils", preserve=PRESERVE_DIRECT);'

RUN julia -e 'using Pkg; Pkg.add("Test", preserve=PRESERVE_DIRECT);'

RUN julia -e 'using Pkg; Pkg.add("PkgTemplates", preserve=PRESERVE_DIRECT);'

#RUN set -eux; \
#    mkdir "$JULIA_USER_HOME";

RUN julia -e 'using Pkg; Pkg.instantiate();'

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

#EXPOSE 8000

COPY src src
COPY test test

#RUN julia src/Examples.jl