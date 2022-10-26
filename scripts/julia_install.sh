#!/bin/bash
JULIA_VERSION="1.7.2"
JULIA_THREADS=1

apt-get update && apt-get upgrade -y && apt-get install -y apt-utils gcc g++ openssh-server cmake build-essential gdb gdbserver rsync locales
apt-get install -y bzip2 wget gnupg dirmngr apt-transport-https tzdata ca-certificates openssh-server tmux && apt-get clean

RUN julia -e 'using Pkg; Pkg.add("HTTP", preserve=PRESERVE_DIRECT);'


julia -e 'using Pkg; Pkg.add("URIs", preserve=PRESERVE_DIRECT);'
julia -e 'using Pkg; Pkg.add("JSON3", preserve=PRESERVE_DIRECT);'
julia -e 'using Pkg; Pkg.add("JSON", preserve=PRESERVE_DIRECT);'
julia -e 'using Pkg; Pkg.add("Statistics", preserve=PRESERVE_DIRECT);'

julia -e 'using Pkg; Pkg.add("InteractiveUtils", preserve=PRESERVE_DIRECT);'

julia -e 'using Pkg; Pkg.add("Test", preserve=PRESERVE_DIRECT);'

julia -e 'using Pkg; Pkg.add("PkgTemplates", preserve=PRESERVE_DIRECT);'

julia -e 'using Pkg; Pkg.instantiate();'

exec "$@"