# Commander Genius for Switch Docker builder
This repository contains a Dockerfile to create a container cross compiling Commander Genius for Nintendo Switch.

The container copies the build artifacts (binary/nro, debug symbols and log files) to /artifacts. Thus this should be a mounted persistent volume. It also supports mounting /ccache which greatly improves compilation speeds by caching binaries. Additionally the container supports changing the UID and GID used for compilation by defining environment variables with the same name.
There are two ways of operating the container, by default it executes cron which emits one build every day. Though instead it is also possible to execute /build.sh for a single compilation, the container will stop afterwards. ("docker run --rm -v /path/to/cache/:/ccache -v /path/to/artifacts:/artifacts -it cgswitch /build.sh")
