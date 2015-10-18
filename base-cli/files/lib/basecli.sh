cli::err () {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}
cli::usage () {
    echo -e "$@" >&2
}
