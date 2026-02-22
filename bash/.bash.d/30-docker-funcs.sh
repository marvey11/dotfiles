#
# Remove all docker containers, including stopped ones
#
function docker-rm-all() {
    docker ps -a | awk 'NR != 1 { print $1; }' | xargs docker rm
}
