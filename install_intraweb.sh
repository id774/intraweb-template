#!/bin/sh
#
########################################################################
# Install Intraweb Template
#
#  Maintainer: id774 <idnanashi@gmail.com>
#
#  v0.2 2/5,2012
#       Rename config file.
#  v0.1 4/6,2011
#       First.
########################################################################

setup_environment() {
    REPO_ROOT=$HOME/intraweb-template
    DOCUMENT_ROOT=/var/www
    HTTP_CONF=/etc/apache2/sites-available/custom.conf
    HTTPS_CONF=/etc/apache2/sites-available/custom-ssl.conf
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
    sudo cp -R $REPO_ROOT/html $DOCUMENT_ROOT
    sudo chown -R $OWNER $DOCUMENT_ROOT
}

install_rubybook() {
    sudo apt-get -y install rubybook
    sudo ln -fs /usr/share/doc/rubybook/html \
        $DOCUMENT_ROOT/html/rubybook
}

apache_settings() {
    sudo cp $REPO_ROOT/conf/custom.conf $HTTP_CONF
    sudo chmod 644 $HTTP_CONF
    sudo chown root:root $HTTP_CONF
    sudo vi $HTTP_CONF
    sudo vi $DOCUMENT_ROOT/html/index.html
    sudo a2dissite default
    sudo a2ensite custom
}

enable_ssl() {
    test -d /etc/apache2/ssl || sudo mkdir -p /etc/apache2/ssl
    sudo /usr/sbin/make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/apache.pem
    sudo cp $REPO_ROOT/conf/custom-ssl.conf $HTTPS_CONF
    sudo chmod 644 $HTTPS_CONF
    sudo chown root:root $HTTPS_CONF
    sudo vi $HTTPS_CONF
    sudo a2enmod ssl
    sudo a2dissite default-ssl
    sudo a2ensite custom-ssl
    sudo /etc/init.d/apache2 restart
}

main() {
    setup_environment
    clear_dir $DOCUMENT_ROOT/html
    test -f $DOCUMENT_ROOT/index.html && sudo rm $DOCUMENT_ROOT/index.html
    setup_intraweb
    if [ -f /etc/debian_version ]; then
        install_rubybook
    fi
    apache_settings
    enable_ssl
}

main
