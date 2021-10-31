#! /bin/sh

echo "SANED_ACL = [ $SANED_ACL ]"
echo "SANED_DLL = [ $SANED_DLL ]"
echo "SANED_DEVICE = $SANED_DEVICE"

# set ACL from environment variable
if [ -n "$SANED_ACL" ]; then
    echo $SANED_ACL >> /etc/sane.d/saned.conf
else
    echo "localhost" >> /etc/sane.d/saned.conf
fi

# limit data_portrange to 10000 - 10001
sed -i 's/^#\s*data_portrange\s*=\s*.*$/data_portrange = 10000 - 10001/g' /etc/sane.d/saned.conf

# check if the saned device is configured
if [ -z "$SANED_DEVICE" ]; then
    echo "You need to set the environment variable SANED_DEVICE to some scanner returned by 'scanimage -L'."
    exit 1
fi

# set the DLL (optional)
if [ -n "$SANED_DLL" ]; then
    echo $SANED_DLL >> /etc/sane.d/dll.conf
fi

# set the log level for saned
#if [ -z "$SANED_LOG_LEVEL" ]; then
#    export SANED_LOG_LEVEL = 2
#fi

# create the run folder for dbus (because it is missing sometimes)
if [ ! -d "/var/run/dbus" ]; then
    mkdir -p /var/run/dbus
fi

# remove the pid file from the previous run (if it exists)
if [ -e "/var/run/dbus/pid" ]; then
    rm /var/run/dbus/pid
fi
