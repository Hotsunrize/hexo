FROM centos:7
MAINTAINER hotsunrize http://uzi.cool

#workdir
WORKDIR /app/web
ENV BLOG_URL "blog.uzi.cool"

#yum install
RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install wget git && \
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

ENV LC_ALL "zh_CN.UTF-8"

#port
EXPOSE 4000 443

#vlomue
VOLUME /app/web/${BLOG_URL}

#workdir
WORKDIR /app/web/${BLOG_URL}


#command
ENTRYPOINT ["/bin/hexo", "server"]
