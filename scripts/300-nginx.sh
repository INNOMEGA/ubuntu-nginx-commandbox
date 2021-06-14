#!/bin/bash

web_root="/web"

echo "Installing nginx"
apt-get install nginx
echo "Adding CommandBox nginx configuration files"
cp etc/nginx/conf.d/nginx-custom-global.conf /etc/nginx/conf.d/nginx-custom-global.conf
cp etc/nginx/commandbox.conf /etc/nginx/commandbox.conf
cp etc/nginx/commandbox-proxy.conf /etc/nginx/commandbox-proxy.conf

echo "Adding Default and Example Site to nginx"
cp etc/nginx/sites-available/*.conf /etc/nginx/sites-available/
echo "Removing nginx default site"
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

echo "Creating web root and default sites here: " $web_root
mkdir $web_root
mkdir $web_root/ssd.innomega.se
mkdir $web_root/ssd.innomega.se/wwwroot

echo "Adding our default site"
ln -s /etc/nginx/sites-available/ssd.innomega.se.conf /etc/nginx/sites-enabled/ssd.innomega.se.conf

echo "Creating a default index.html"
echo "<!doctype html><html><body><h2>Hello (html)</h2></body></html>" > $web_root/ssd.innomega.se/wwwroot/index.html

echo "Creating a default index.cfm"
echo "<!doctype html><html><body><h1>Hello (cfm)</h1>Now is <cfoutput>#now()#</cfoutput>.</body></html>" > $web_root/ssd.innomega.se/wwwroot/index.cfm

#set the web directory permissions
chown -R root:www-data $web_root/ssd.innomega.se/wwwroot
chmod -R 750 $web_root/ssd.innomega.se/wwwroot

echo "Starting up CommandBox instances"
box server start name=ssd.innomega.se port=8080 host=127.0.1.1 cfengine=$CF_ENGINE serverConfigFile=$WEB_ROOT/ssd.innomega.se/server.json webroot=$WEB_ROOT/ssd.innomega.se/www rewritesEnable=$REWRITES_ENABLED openbrowser=false saveSettings=true --force;


if [ "$REWRITES_ENABLED" = "true" ]; then
        sed -i "s/#REWRITES_ENABLED# //g" /etc/nginx/commandbox-proxy.conf
        sed -i "s/#REWRITES_ENABLED# //g" /etc/nginx/sites-available/ssd.innomega.se.conf
fi


#------------------------------
# Inject user defined $WEB_ROOT
#------------------------------
sed -i "s%root WEB_ROOT%root $WEB_ROOT%g" /etc/nginx/sites-available/ssd.innomega.se.conf


if [ "$WHITELIST_IP" != "" ];then
	echo "Granting $WHITELIST_IP access to /lucee"
	sed -i "s/#allow 10.0.0.10/allow $WHITELIST_IP/g" /etc/nginx/commandbox.conf
fi

if [ "$HOST_NAME" != "" ];then
	echo "Setting default site hostname"
	echo $HOST_NAME
	sed -i "s/#server_name xxx.com/server_name $HOST_NAME/g" /etc/nginx/sites-available/ssd.innomega.se.conf
fi


service nginx restart
