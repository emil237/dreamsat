#!/bin/sh

#wget -q "--no-check-certificate" https://raw.githubusercontent.com/emil237/dreamsat/main/installer1.sh -O - | /bin/sh
##############################################################################
VERSION=1.4
PLUGIN_PATH='/usr/lib/enigma2/python/Plugins/Extensions/DreamSat'

if [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OS='DreamOS'
elif [ -f /etc/opkg/opkg.conf ] ; then
   STATUS='/var/lib/opkg/status'
   OS='Opensource'
fi

# remove old version
# rm -f /var/etc/.stcpch.cfg > /dev/null 2>&1
# rm -rf /usr/local/chktools > /dev/null 2>&1
if [ /media/ba/DreamSat ]; then
    rm -rf /media/ba/DreamSat > /dev/null 2>&1
    rm -rf /usr/lib/enigma2/python/Plugins/Extensions/DreamSat > /dev/null 2>&1
else
    rm -rf /usr/lib/enigma2/python/Plugins/Extensions/DreamSat > /dev/null 2>&1
fi

if [ -d $PLUGIN_PATH ]; then

   rm -rf $PLUGIN_PATH
  
fi

if python --version 2>&1 | grep -q '^Python 3\.'; then
   echo "You have Python3 image"
   PYTHON='PY3'
   IMAGING='python3-imaging'
   PYSIX='python3-six'
fi

if grep -q $IMAGING $STATUS; then
    imaging='Installed'
fi

if grep -q $PYSIX $STATUS; then
    six='Installed'
fi

if [ $imaging = "Installed" -a $six = "Installed" ]; then
     echo "All dependecies are installed"
else

    if [ $OS = "Opensource" ]; then
        echo "=========================================================================="
        echo "Some Depends Need to Be downloaded From Feeds ...."
        echo "=========================================================================="
        echo "Opkg Update ..."
        echo "========================================================================"
        opkg update
        echo "========================================================================"
        echo " Downloading $IMAGING , $PYSIX ......"
        opkg install $IMAGING
        echo "========================================================================"
        opkg install $PYSIX
        echo "========================================================================"
    else
        echo "=========================================================================="
        echo "Some Depends Need to Be downloaded From Feeds ...."
        echo "=========================================================================="
        echo "apt Update ..."
        echo "========================================================================"
        apt-get update
        echo "========================================================================"
        echo " Downloading $IMAGING , $PYSIX ......"
        apt-get install $IMAGING -y
        echo "========================================================================"
        apt-get install $PYSIX -y
        echo "========================================================================"
    fi


fi

if grep -q $IMAGING $STATUS; then
    echo ""
else
    echo "#########################################################"
    echo "#       $IMAGING Not found in feed                      #"
    echo "#########################################################"
fi

if grep -q $PYSIX $STATUS; then
    echo ""
else
    echo "#########################################################"
    echo "#       $PYSIX Not found in feed                        #"
    echo "#########################################################"
    exit 1
fi

sleep 1;

cd /tmp
 
echo "===> Downloading And Insallling DreamSAtPAneL plugin For Python3.10 Please Wait ......"
echo
wget "https://raw.githubusercontent.com/emil237/dreamsat/main/DreamSat-Panel_1.4_py-3.10.tar.gz"
tar -xzf DreamSat-Panel_1.4_py-3.10.tar.gz -C /
set +e
rm -f DreamSat-Panel_1.4_py-3.10.tar.gz
      

## This commands to save plugin from BA protection
if [ $OS = 'DreamOS' ]; then
    if [ "/media/ba" -a "/usr/lib/enigma2/python/Plugins/Extensions/DreamSat" ]; then
        mv /usr/lib/enigma2/python/Plugins/Extensions/DreamSat /media/ba
        ln -s /media/ba/DreamSat /usr/lib/enigma2/python/Plugins/Extensions
    fi
fi
##

echo ""
echo "#########################################################"
echo "#     DreamSatPanel $VERSION INSTALLED SUCCESSFULLY          #"
echo "#                    BY Linuxsat                        #"
echo "#########################################################"
echo "#                Restart Enigma2 GUI                    #"
echo "#########################################################"
sleep 2
if [ $OS = 'DreamOS' ]; then
    systemctl restart enigma2
else
    killall -9 enigma2
fi
exit 0
