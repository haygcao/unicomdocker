FROM node:lts-alpine
LABEL maintainer="clamp <imclamp@foxmail.com>"
ARG ASM_WRAPPER_URL=https://github.com/haygcao/unicomdocker.git
ARG ASM_WRAPPER_BRANCH=master
ARG enable_unicom=true
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
    ASM_DIR=/AutoSignMachine \
    ENABLE_HANGUP=true \
    ENABLE_WEB_PANEL=true 
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f bash \
    coreutils \
    moreutils \
    git \
    wget \
    curl \
    nano \
    tzdata \
    perl \
    openssl \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && git clone -b ${ASM_WRAPPER_BRANCH} ${ASM_WRAPPER_URL} ${ASM_DIR} \
    && cd ${ASM_DIR}/panel \
    && npm install \
    && npm install -g pm2 \
   
    && ln -sf ${ASM_DIR}/git_pull.sh /usr/local/bin/git_pull \
    && ln -sf ${ASM_DIR}/rm_log.sh /usr/local/bin/rm_log \
   
    && cp -f ${ASM_DIR}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh \

    && chmod 777 /usr/local/bin/docker-entrypoint.sh \

WORKDIR ${ASM_DIR}
ENTRYPOINT docker-entrypoint.sh
