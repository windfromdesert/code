#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS 5.x & 6.x & 7 (32bit/64bit)
#   Description:  Install Shadowsocks(go) for CentOS
#   Author: Teddysun <i@teddysun.com>
#   Intro:  http://teddysun.com/392.html
#===============================================================================================

clear
echo "#############################################################"
echo "# Install Shadowsocks(go) for CentOS 5 or 6 or 7 (32bit/64bit)"
echo "# Intro: http://teddysun.com/392.html"
echo "#"
echo "# Author: Teddysun <i@teddysun.com>"
echo "#"
echo "#############################################################"
echo ""

# Make sure only root can run our script
function rootness(){
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi
}

# Get version
function getversion(){
    if [[ -s /etc/redhat-release ]];then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else    
        grep -oE  "[0-9.]+" /etc/issue
    fi    
}

# CentOS version
function centosversion(){
    local code=$1
    local version="`getversion`"
    local main_ver=${version%%.*}
    if [ $main_ver == $code ];then
        return 0
    else
        return 1
    fi        
}

# is 64bit or not
function is_64bit(){
    if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
        return 0
    else
        return 1
    fi        
}

# Disable selinux
function disable_selinux(){
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi
}

# Pre-installation settings
function pre_install(){
    # Set shadowsocks-go config password
    echo "Please input password for shadowsocks-go:"
    read -p "(Default password: wangbin):" shadowsockspwd
    if [ "$shadowsockspwd" = "" ]; then
        shadowsockspwd="wangbin"
    fi
    echo "password:$shadowsockspwd"
    echo "####################################"
    get_char(){
        SAVEDSTTY=`stty -g`
        stty -echo
        stty cbreak
        dd if=/dev/tty bs=1 count=1 2> /dev/null
        stty -raw
        stty echo
        stty $SAVEDSTTY
    }
    echo ""
    echo "Press any key to start...or Press Ctrl+C to cancel"
    char=`get_char`
    #Install necessary dependencies
    yum install -y wget unzip gzip curl
    # Get IP address
    echo "Getting Public IP address, Please wait a moment..."
    IP=`curl -s checkip.dyndns.com | cut -d' ' -f 6  | cut -d'<' -f 1`
    if [ -z $IP ]; then
        IP=`curl -s ifconfig.me/ip`
    fi
    echo -e "Your main public IP is\t\033[32m$IP\033[0m"
    echo ""
    #Current folder
    cur_dir=`pwd`
}

# Download shadowsocks-go
function download_files(){
    cd $cur_dir
    if is_64bit; then
        if ! wget -c http://lamp.teddysun.com/shadowsocks/shadowsocks-server-linux64-1.1.3.gz;then
            echo "Failed to download shadowsocks-server-linux64-1.1.3.gz"
            exit 1
        fi
        gzip -d shadowsocks-server-linux64-1.1.3.gz
        if [ $? -eq 0 ];then
            echo "Decompress shadowsocks-server-linux64-1.1.3.gz success."
        else
            echo "Decompress shadowsocks-server-linux64-1.1.3.gz failed! Please check gzip command."
            exit 1
        fi
        mv -f shadowsocks-server-linux64-1.1.3 /usr/bin/shadowsocks-server
    else
        if ! wget -c http://lamp.teddysun.com/shadowsocks/shadowsocks-server-linux32-1.1.3.gz;then
            echo "Failed to download shadowsocks-server-linux32-1.1.3.gz"
            exit 1
        fi
        gzip -d shadowsocks-server-linux32-1.1.3.gz
        if [ $? -eq 0 ];then
            echo "Decompress shadowsocks-server-linux32-1.1.3.gz success."
        else
            echo "Decompress shadowsocks-server-linux32-1.1.3.gz failed! Please check gzip command."
            exit 1
        fi
        mv -f shadowsocks-server-linux32-1.1.3 /usr/bin/shadowsocks-server
    fi

    # Download start script
    if ! wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-go; then
        echo "Failed to download shadowsocks-go start script!"
        exit 1
    fi
}

# Config shadowsocks
function config_shadowsocks(){
    if [ ! -d /etc/shadowsocks ];then
        mkdir /etc/shadowsocks
    fi
    cat > /etc/shadowsocks/config.json<<-EOF
{
    "server":"${IP}",
    "server_port":3838,
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "method":"aes-256-cfb",
    "timeout":600
}
EOF
}

# iptables set
function iptables_set(){
    echo "iptables start setting..."
    /sbin/service iptables status 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
        /etc/init.d/iptables status | grep '3838' | grep 'ACCEPT' >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            /sbin/iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 3838 -j ACCEPT
            /etc/init.d/iptables save
            /etc/init.d/iptables restart
        else
            echo "port 3838 has been set up."
        fi
    else
        echo "iptables looks like shutdown, please manually set it if necessary."
    fi
}

# Install 
function install(){
    # Install shadowsocks-go
    if [ -s /usr/bin/shadowsocks-server ];then
        echo "shadowsocks-go install success!"
        chmod +x /usr/bin/shadowsocks-server
        mv $cur_dir/shadowsocks-go /etc/init.d/shadowsocks
        chmod +x /etc/init.d/shadowsocks
        # Add run on system start up
        chkconfig --add shadowsocks
        chkconfig shadowsocks on
        # Start shadowsocks
        /etc/init.d/shadowsocks start
        if [ $? -eq 0 ]; then
            echo "Shadowsocks-go start success!"
        else
            echo "Shadowsocks-go start failure!"
        fi
    else
        echo "shadowsocks-go install failed!"
        exit 1
    fi
    cd $cur_dir
    clear
    echo ""
    echo "Congratulations, shadowsocks-go install completed!"
    echo -e "Your Server IP: \033[41;37m ${IP} \033[0m"
    echo -e "Your Server Port: \033[41;37m 3838 \033[0m"
    echo -e "Your Password: \033[41;37m ${shadowsockspwd} \033[0m"
    echo -e "Your Local Port: \033[41;37m 1080 \033[0m"
    echo -e "Your Encryption Method: \033[41;37m aes-256-cfb \033[0m"
    echo ""
    echo "Welcome to visit:http://teddysun.com/392.html"
    echo "Enjoy it!"
    echo ""
    exit 0
}

# Uninstall Shadowsocks-go
function uninstall_shadowsocks_go(){
    printf "Are you sure uninstall shadowsocks-go? (y/n) "
    printf "\n"
    read -p "(Default: n):" answer
    if [ -z $answer ]; then
        answer="n"
    fi
    if [ "$answer" = "y" ]; then
        ps -ef | grep -v grep | grep -v ps | grep -i "shadowsocks-server" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            /etc/init.d/shadowsocks stop
        fi
        chkconfig --del shadowsocks
        # delete config file
        rm -rf /etc/shadowsocks
        # delete shadowsocks
        rm -f /etc/init.d/shadowsocks
        rm -f /usr/bin/shadowsocks-server
        echo "Shadowsocks-go uninstall success!"
    else
        echo "Uninstall cancelled, Nothing to do"
    fi
}

# Install Shadowsocks-go
function install_shadowsocks_go(){
    rootness
    disable_selinux
    pre_install
    download_files
    config_shadowsocks
    if ! centosversion 7; then
        iptables_set
    fi
    install
}

# Initialization step
action=$1
[  -z $1 ] && action=install
case "$action" in
install)
    install_shadowsocks_go
    ;;
uninstall)
    uninstall_shadowsocks_go
    ;;
*)
    echo "Arguments error! [${action} ]"
    echo "Usage: `basename $0` {install|uninstall}"
    ;;
esac
