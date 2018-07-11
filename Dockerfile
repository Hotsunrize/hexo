FROM centos:7
MAINTAINER hotsunrize http://uzi.cool

#workdir
WORKDIR /app/web
ENV BLOG_URL "blog.uzi.cool"

#yum install
RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install wget git vim python-pip && \
    /usr/bin/pip install supervisor && \
    yum -y install kde-l10n-Chinese && \
    yum -y reinstall glibc-common && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \
    yum -y install npm && \
    npm install hexo-cli -g && \
    hexo init ${BLOG_URL} && \
    cd ${BLOG_URL} && \
    npm install && \
    cd themes/ && \
    git clone https://github.com/iissnan/hexo-theme-next.git && \
    yum clean all

#config
RUN sed -i "s/^url:.*$/url: http:\/\/${BLOG_URL}/g" /app/web/${BLOG_URL}/_config.yml && \
    sed -i "s/^language:.*$/language: zh-Hans/g" /app/web/${BLOG_URL}/_config.yml && \
    sed -i "s/^theme:.*$/theme: hexo-theme-next/g" /app/web/${BLOG_URL}/_config.yml && \
    mkdir /etc/supervisor.d && \
    /usr/bin/echo_supervisord_conf >/etc/supervisord.conf && \
    sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf && \
    echo -e '[include]\nfiles=/etc/supervisor.d/*.ini' >>/etc/supervisord.conf && \
    grep ^[^\;] /etc/supervisord.conf

ADD hexo.ini /etc/supervisor.d/hexo.ini

ENV LC_ALL "zh_CN.UTF-8"

#port
EXPOSE 4000 443

#vlomue
VOLUME /app/web/${BLOG_URL}

#workdir
WORKDIR /app/web/${BLOG_URL}


#command
ENTRYPOINT ["/usr/bin/supervisord"]
