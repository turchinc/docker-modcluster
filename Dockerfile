FROM debian:jessie

RUN apt-get update
RUN apt-get install -y autoconf libtool apache2-prefork-dev apache2

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

ADD https://codeload.github.com/modcluster/mod_cluster/tar.gz/1.3.0.Final /
RUN tar -zxvf 1.3.0.Final
RUN rm 1.3.0.Final
WORKDIR mod_cluster-1.3.0.Final
RUN cd native/advertise; ./buildconf; ./configure --with-apxs=/usr/bin/apxs; make; cp *.so /usr/lib/apache2/modules/
RUN cd native/mod_manager; ./buildconf; ./configure --with-apxs=/usr/bin/apxs; make; cp *.so /usr/lib/apache2/modules/
RUN cd native/mod_proxy_cluster; ./buildconf; ./configure --with-apxs=/usr/bin/apxs; make; cp *.so /usr/lib/apache2/modules/
RUN cd native/mod_cluster_slotmem; ./buildconf; ./configure --with-apxs=/usr/bin/apxs; make; cp *.so /usr/lib/apache2/modules/
WORKDIR /
RUN rm -rf mod_cluster-1.3.0.Final

ADD proxy_cluster.load /etc/apache2/mods-available/
ADD cluster.conf /etc/apache2/conf-available/

RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/proxy_ajp.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/proxy_cluster.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/conf-available/cluster.conf /etc/apache2/conf-enabled/

ADD html/ /var/www/html/

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
