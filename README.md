# Repo for RLP COVID-19 Installation

Demo: https://eden.geospatial-interoperability-solutions.eu/

Installation on empty debian 9 server (with python3 enabled):

```console
#https://linuxconfig.org/how-to-change-default-python-version-on-debian-9-stretch-linux
update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
update-alternatives --install  /usr/bin/python python /usr/bin/python3.5 2
update-alternatives --config python # set to 3.5.3
mkdir /data/
mkdir /data/sahana
wget https://raw.githubusercontent.com/armin11/eden/master/install-eden-nginx-postgis.sh
chmod +x install-eden-nginx-postgis.sh
./install-eden-nginx-postgis.sh
pip3 install uwsgi
pip3 install psycopg2
wget https://raw.githubusercontent.com/armin11/eden/master/configure-eden-nginx-postgis.sh
chmod +x configure-eden-nginx-postgis.sh
./configure-eden-nginx-postgis.sh
#for dummy localhost installation give following values
#domain - localhost
#host - eden
#template - covid-19
#database user password - sahana
#don't add ssl certificate - choose 'c'
#after installation adopt /etc/nginx/nginx.conf and /etc/init.d/sites-enabled/prod.conf
```



# Sahana Eden

Sahana Eden is an Emergency Development Environment - an Open Source framework to rapidly build powerful applications for Emergency Management.

It is a web based collaboration tool that addresses the common coordination problems during a disaster from finding missing people, managing aid, managing volunteers, tracking camps effectively between Government groups, the civil society (NGOs) and the victims themselves.

Please see the website for more details: 
+ http://eden.sahanafoundation.org/

Note to developers -- get started here:
+ http://eden.sahanafoundation.org/wiki/Develop

Before your first pull request, sign the Contributor's License Agreement, which protects your rights to your code, while allowing it to be distributed and used in Sahana Eden:
+ http://bit.ly/SSF-eCLA
