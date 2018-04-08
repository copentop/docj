FROM centos:latest
MAINTAINER copentop


# yum源
ENV CENTOS_7_ALI http://mirrors.aliyun.com/repo/Centos-7.repo
# node 版本
ENV NODE_VERSION 8.11.1
# nginx 版本
ENV NGINX_VERSION 1.13.8


#nodejs 环境变量
ENV PATH="/usr/local/node-v${NODE_VERSION}-linux-x64/bin:$PATH"
#nginx 环境变量
ENV PATH="/usr/local/nginx/sbin:$PATH"

# 支持库
# 更新源、安装常用库、安装nginx、nodejs、cnpm、pm2、nginx
RUN cd /etc/yum.repos.d/ \
    && mv CentOS-Base.repo CentOS-Base.repo.bak \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo ${CENTOS_7_ALI} \
    && yum clean all \
    && yum makecache \
    && yum -y update \
    && yum -y install gcc-c++  \
    && yum -y install pcre pcre-devel \ 
    && yum -y install zlib zlib-devel \ 
    && yum -y install openssl openssl--devel \
    && yum -y install autoconf libjpeg libjpeg-devel libpng libpng-devel \
    && yum -y install freetype freetype-devel curl curl-devel libxml2 libxml2-devel \
    && yum -y install glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel \
    && cd /usr/local \
    && curl -SLO "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    && tar -zxvf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd /usr/local \
    && rm -rf /usr/local/nginx-${NGINX_VERSION}.tar.gz \
    && rm -rf /usr/local/nginx-${NGINX_VERSION} \
    && mkdir /usr/local/nginx/conf/nginx_vhosts \
    && mkdir -p /var/www/demo.com \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz"  \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org \
    && cnpm install -g pm2 \
    && yum clean all 

# 复制nginx配置
COPY ./nginx/nginx.conf /usr/local/nginx/conf
#COPY ./nginx/nginx_vhosts/demo.com.conf /usr/local/nginx/conf/nginx_vhosts

EXPOSE 22 80 443


# nginx 后台执行命令
CMD ["nginx", "-g", "daemon off;"]