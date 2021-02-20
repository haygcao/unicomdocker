FROM node:lts-alpine
LABEL maintainer="clamp <imclamp@foxmail.com>"
ARG ASM_SCRIPTS_URL=https://github.com/DJ-clamp/BaseSation
ARG ASM_SCRIPTS_BRANCH=dev
ARG ASM_WRAPPER_URL=https://github.com/haygcao/unicomdocker
ARG ASM_WRAPPER_BRANCH=master
ARG enable_unicom=true
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
    ASM_DIR=/AutoSignMachine \ 
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
    && cp -f ${ASM_DIR}/task_shell_script.sh /usr/local/bin/task_shell_script.sh \
    && git clone -b ${ASM_SCRIPTS_BRANCH} ${ASM_SCRIPTS_URL} ${ASM_DIR}/scripts \
    && cd ${ASM_DIR}/scripts \
    && npm install \
    && cp -f ${ASM_DIR}/docker/docker_entrypoint.sh /docker_entrypoint.sh \
    && chmod 777 /docker_entrypoint.sh

WORKDIR ${ASM_DIR}
ENTRYPOINT /docker_entrypoint.sh
