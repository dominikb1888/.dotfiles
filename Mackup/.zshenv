source "$HOME/.cargo/env"

[ -x /usr/libexec/path_helper ] && eval $(/usr/libexec/path_helper -s)

export JAVA_HOME=$(/usr/libexec/java_home)
. "$HOME/.cargo/env"
