#!/bin/sh
#
########################################################################
# Install Intraweb Template
#
#  Maintainer: id774 <idnanashi@gmail.com>
#
#  v0.1 4/6,2011
#       First.
########################################################################

setup_environment() {
    REPO_ROOT=$HOME/intraweb-template
    DOCUMENT_ROOT=/var/www
    HTTP_CONF=/etc/apache2/sites-available/default 
    case $OSTYPE in
      *darwin*)
        OWNER=root:wheel
        ;;
      *)
        OWNER=root:root
        ;;
    esac
}

clear_dir() {
    if [ -L $1 ]; then
        sudo rm $1
    fi
    if [ -d $1 ]; then
        sudo rm -rf $1
    fi
}

setup_intraweb() {
    sudo cp -R $HTTP_CONF $REPO_ROOT/html $DOCUMENT_ROOT
    sudo chown -R $OWNER $DOCUMENT_ROOT
}

install_rubybook() {
    sudo apt-get -y install rubybook
    sudo ln -fs /usr/share/doc/rubybook/html \
        $DOCUMENT_ROOT/html/rubybook
}

apache_settings() {
    sudo vim $APACHE_CONF $REPO_ROOT/conf/default
    sudo vim $DOCUMENT_ROOT/html/index.html
    sudo /etc/init.d/apache2 restart
}

main() {
    setup_environment
    clear_dir $DOCUMENT_ROOT/html
    setup_intraweb
    if [ -f /etc/debian_version ]; then
        install_rubybook
    fi
    apache_settings
}

main
