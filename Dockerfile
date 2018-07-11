FROM centos:7 
MAINTAINER hotsunrize http://uzi.cool

#yum install
RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install wget git && \
    yum -y install kde-l10n-Chinese && \
    yum -y reinstall glibc-common && \
    yum -y install npm && \
    yum clean all && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

#set env
ENV LC_ALL "zh_CN.UTF-8"
ENV BLOG_URL "blog.uzi.cool"
ENV PATH "/app/web"

#workdir
WORKDIR ${PATH}

#npm install
RUN npm install hexo-cli -g && \
    hexo init ${BLOG_URL} && \
    cd ${BLOG_URL} && \
    npm install && \
    cd ${BLOG_URL}/themes/ && \
    git clone https://github.com/iissnan/hexo-theme-next.git && \
    cd ..

#volumes
VOLUME ${PATH}

#port
EXPOSE 4000 443

#command
ENTRYPOINT ["/bin/hexo", "server"]
