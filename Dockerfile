FROM debian:jessie

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN apt-get update && apt-get install -y curl autoconf libtool apache2-prefork-dev apache2 && \
    curl -O https://codeload.github.com/modcluster/mod_cluster/tar.gz/1.3.0.Final && tar -zxvf 1.3.0.Final && \
    cd /mod_cluster-1.3.0.Final/native/advertise           && ./buildconf && ./configure --with-apxs=/usr/bin/apxs && make; cp *.so /usr/lib/apache2/modules/ && \
    cd /mod_cluster-1.3.0.Final/native/mod_manager         && ./buildconf && ./configure --with-apxs=/usr/bin/apxs && make; cp *.so /usr/lib/apache2/modules/ && \
    cd /mod_cluster-1.3.0.Final/native/mod_proxy_cluster   && ./buildconf && ./configure --with-apxs=/usr/bin/apxs && make; cp *.so /usr/lib/apache2/modules/ && \
    cd /mod_cluster-1.3.0.Final/native/mod_cluster_slotmem && ./buildconf && ./configure --with-apxs=/usr/bin/apxs && make; cp *.so /usr/lib/apache2/modules/ && \
    apt-get purge -y curl autoconf libtool apache2-prefork-dev && apt-get autoremove -y && apt-get clean && \
    rm /1.3.0.Final && rm -rf /mod_cluster-1.3.0.Final

ADD proxy_cluster.load /etc/apache2/mods-available/
ADD cluster.conf /etc/apache2/conf-available/

RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/ && \
    ln -s /etc/apache2/mods-available/proxy_ajp.load /etc/apache2/mods-enabled/ && \
    ln -s /etc/apache2/mods-available/proxy_cluster.load /etc/apache2/mods-enabled/ && \
    ln -s /etc/apache2/conf-available/cluster.conf /etc/apache2/conf-enabled/

ADD html/ /var/www/html/

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
