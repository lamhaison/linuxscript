DES_DIR=/tmp
CONFIG_FILE_NAME=myconfig.cfg
CONTROLLER_IP=10.200.0.2 && USER_NAME=admin && PASSWORD=publiccloud::dashboard

# Create test config file
echo "ip=xxx" > $DES_DIR/$CONFIG_FILE_NAME && \
echo "user=xxx" >> $DES_DIR/$CONFIG_FILE_NAME && \
echo "password=xxx" >> $DES_DIR/$CONFIG_FILE_NAME

# Replace config to new value
sed -ri "s|ip ?= ?(.*)$|ip=$CONTROLLER_IP|" $DES_DIR/$CONFIG_FILE_NAME && \
sed -ri "s|user ?= ?(.*)$|user=$USER_NAME|" $DES_DIR/$CONFIG_FILE_NAME && \
sed -ri "s|password ?= ?(.*)$|password=$PASSWORD|" $DES_DIR/$CONFIG_FILE_NAME

# check result
cat $DES_DIR/$CONFIG_FILE_NAME

# Remove test file
rm -rf $DES_DIR/$CONFIG_FILE_NAME
