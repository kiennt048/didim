yum -yy install acc make gcc-c++ pcre-devel ca-certificates
mkdir /usr/local/download
cd /usr/local/download
wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz 
wget https://archive.apache.org/dist/apr/apr-1.7.0.tar.gz
wget https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz
wget https://archive.apache.org/dist/httpd/httpd-2.4.54.tar.gz
tar zxvf pcre-8.45.tar.gz 
tar zxvf httpd-2.4.54.tar.gz 
tar zxvf apr-1.7.0.tar.gz 
tar zxvf apr-util-1.6.1.tar.gz
cd pcre-8.45
./configure --prefix=/usr/local/src 
make && make install
cd  /usr/local/download
mv apr-1.7.0 ./httpd-2.4.54/srclib/apr
mv apr-util-1.6.1 ./httpd-2.4.54/srclib/apr-util
yum install -yy expat-devel
cd httpd-2.4.54
./configure --prefix=/usr/local/apache --enable-mods-shared=all --enable-mpms-shared=all --with-included-apr --with-pcre=/usr/local/src --enable-so --enable-rewrite --enable-proxy --enable-proxy-ajp --enable-proxy-balancer --enable-proxy-http --enable-alias --enable-ssl --enable-module=headers --enable-deflate --enable-unique-id
make && make install
cd /usr/local/apache/bin
./httpd -V
cd /usr/local/apache/conf
sed -i -e "s/User daemon/User nobody/g" /usr/local/apache/conf/httpd.conf
sed -i -e "s/Group daemon/Group nobody/g" /usr/local/apache/conf/httpd.conf
sed -i -e "s/LoadModule mpm_event_module/#LoadModule mpm_event_module/g" /usr/local/apache/conf/httpd.conf
sed -i -e "s/#LoadModule mpm_worker_module/LoadModule mpm_worker_module/g" /usr/local/apache/conf/httpd.conf

sed -i -e "s/#ServerName www.example.com:80/ServerName localhost/g" /usr/local/apache/conf/httpd.conf
cd /usr/local/apache/bin
./httpd -t
./apachectl -k start
ps -ef | grep httpd
netstat -anlp  | grep 80


