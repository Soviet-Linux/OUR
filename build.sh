

CCCP_ARGS="debug 3 verbose"


buildpkg() {
    echo "Building " $1 "..."

    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
    fi


    # Path: build.sh
    srcpath=$1
    binpath=$(realpath $(dirname $(dirname $srcpath))/bin/$(basename $srcpath).tar.gz)

    echo "Source path: " $srcpath
    echo "Binary path: " $binpath

    #check if binary exists
    if [ -f $binpath ]; then
        echo "Binary already exists"
        # check if source is newer
        if [ $srcpath -nt $binpath ]; then
            echo "Source is newer than binary"
            echo "Rebuilding..."
        else
            echo "Binary is newer than source"
            echo "Skipping..."
            return 0
        fi
    fi

    # Execute cccp build
    cccp $CCCP_ARGS create $srcpath $binpath
    if [ $? -ne 0 ]; then
        echo "Build failed"
        fails=$((fails+1))
        failedpkgs=$(echo $failedpkgs $srcpath)
        echo $fails " packages failed"
        echo "Failed packages: " $failedpkgs
        exit 1
    fi

    return 0
}

cleanall() {
    echo "Cleaning all packages..."
    find . -name '*.tar.gz' | while read file; do rm $file; done
}

buildall() {

    #check if we are runnning in a soviet system
    cat /etc/os-release| head -n1 | grep 'Soviet Linux' > /dev/null
    if [ $? -ne 0 ]; then
        echo "This script is intended to be run on Soviet Linux"
        read -r -p "Do you wan to launch the docker container ? [y/N] " res
        res=${res,,}    # tolower
        if [[ "$res" =~ ^(yes|y)$ ]] ; then
            
            docker run -v `pwd`:`pwd` -w `pwd` pkd667/sovietlinux sh build.sh build
            exit $?
        else
            read -r -p "Do you wan to continue executing on current system ? [y/N] " res
            res=${res,,}    # tolower
            if [[ "$res" =~ ^(yes|y)$ ]] ; then
                echo "Continuing..."
            else
                echo "Aborting..."
                exit 1
            fi
        fi
    fi
    echo "Building all packages..."
    find . -name '*.ecmp' | while read file; do buildpkg $file; done
}



if [ "$1" == "clean" ]; then
    cleanall
    exit 0
elif [ "$1" == "buildall" ] || [ "$1" == "all" ] || [ "$1" == "" ]; then
    buildall
    exit 0
elif [ "$1" == "buildpkg" ] || [ "$1" == "build" ] || [ "$1" == "pkg" ]  ; then
    buildpkg $2
    exit 0
elif [ "$1" == "help" ]; then
    echo "Usage: build.sh [command] [package]"
    echo
    echo "Commands:"
    echo
    echo "  buildpkg|build|pkg [package] - build a single package"
    echo "    --> The package argument is the path to the package's .ecmp file in the repository"
    echo
    echo "  buildall|all - build all packages"
    echo "    --> If no command is specified, buildall is used"
    echo
    echo "  clean - clean all packages"
    echo
    echo "  help - show this help"
    echo
    exit 0
else
    echo "Unknown command"
    exit 1
fi




