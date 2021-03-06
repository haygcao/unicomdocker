#!/bin/sh
set -e
ScriptsDir=/AutoSignMachine
ScriptsURL=https://github.com/DJ-clamp/BaseSation
## 克隆scripts
function Git_CloneScripts {
  git clone -b dev ${ScriptsURL} ${ScriptsDir}
  ExitStatusScripts=$?
  echo
}

## 更新scripts
function Git_PullScripts {
  cd ${ScriptsDir}
  git fetch --all
  ExitStatusScripts=$?
  git reset --hard origin/dev
  echo
}

  
git pull
npm install --loglevel error --prefix /AutoSignMachine

mergedListFile="/AutoSignMachine/merged_list_file.sh"
echo "定时任务文件路径为 ${mergedListFile}"
echo '' >${mergedListFile}

if [ $ENABLE_52POJIE ]; then
    echo "10 13 * * * sleep \$((RANDOM % 120)); node /AutoSignMachine/index.js 52pojie --htVD_2132_auth=${htVD_2132_auth} --htVD_2132_saltkey=${htVD_2132_saltkey} >> /AutoSignMachine/logs/52pojie.log 2>&1 &" >>${mergedListFile}
else
    echo "未配置启用52pojie签到任务环境变量ENABLE_52POJIE，故不添加52pojie定时任务..."
fi

if [ $ENABLE_BILIBILI ]; then
    echo "*/30 7-22 * * * sleep \$((RANDOM % 120)); node /AutoSignMachine/index.js bilibili --username ${BILIBILI_ACCOUNT} --password ${BILIBILI_PWD} >> /AutoSignMachine/logs/bilibili.log 2>&1 &" >>${mergedListFile}
else
    echo "未配置启用bilibi签到任务环境变量ENABLE_BILIBILI，故不添加Bilibili定时任务..."
fi

if [ $ENABLE_IQIYI ]; then
    echo "*/30 7-22 * * * sleep \$((RANDOM % 120)); node /AutoSignMachine/index.js iqiyi --P00001 ${P00001} --P00PRU ${P00PRU} --QC005 ${QC005}  --dfp ${dfp} >> /AutoSignMachine/logs/iqiyi.log 2>&1 &" >>${mergedListFile}
else
    echo "未配置启用iqiyi签到任务环境变量ENABLE_IQIYI，故不添加iqiyi定时任务..."
fi

if [ $ENABLE_UNICOM ]; then
    if [ -f $UNICOM_CONFIG ]; then
        if type jq >/dev/null 2>&1; then
            echo "jq已存在"
        else
            echo "安装jq"
            apk add jq
        fi
        for accountSn  in `cat ${UNICOM_CONFIG} | jq -r .accountSn | sed 's/,/ /g'`
        do 
            echo "*/30 7-22 * * * sleep \$((RANDOM % 120)); node /AutoSignMachine/index.js unicom --accountSn $accountSn  --config ${UNICOM_CONFIG} >> /AutoSignMachine/logs/unicom${accountSn}.log 2>&1 &" >>${mergedListFile}
        done
    else
        echo "*/30 7-22 * * * sleep \$((RANDOM % 120)); node /AutoSignMachine/index.js unicom --user ${UNICOM_PHONE} --password ${UNICOM_PWD} --appid ${UNICOM_APPID} >> /AutoSignMachine/logs/unicom.log 2>&1 &" >>${mergedListFile}
    fi
    ##兑换流量包脚本环境配置
    if [ $ACTIVE_FLOW ]; then
        if type bash >/dev/null 2>&1; then
            echo "已安装 bash "
        else
            echo "安装bash"
            apk add bash
        fi
        if type openssl >/dev/null 2>&1; then
            echo "已安装 openssl "
        else
            echo "安装openssl"
            apk add openssl
        fi
        if type curl >/dev/null 2>&1; then
            echo "已安装 curl "
        else
            echo "安装curl"
            apk add curl
        fi
    fi
else
    echo "未配置启用unicom签到任务环境变量ENABLE_UNICOM，故不添加unicom定时任务..."
fi

echo "增加默认脚本更新任务..."
echo "21 */1 * * * docker_entrypoint.sh >> /AutoSignMachine/logs/default_task.log 2>&1" >>$mergedListFile



echo "判断是否配置了随即延迟参数..."
if [ $RANDOM_DELAY_MAX ]; then
    if [ $RANDOM_DELAY_MAX -ge 1 ]; then
        echo "已设置随机延迟为 $RANDOM_DELAY_MAX , 设置延迟任务中..."
        sed -i "/node/sleep \$((RANDOM % \$RANDOM_DELAY_MAX)) && node/g" $mergedListFile
    fi
else
    echo "未配置随即延迟对应的环境变量，故不设置延迟任务..."
fi

echo "增加 |ts 任务日志输出时间戳..."
sed -i "/\( ts\| |ts\|| ts\)/!s/>>/\|ts >>/g" $mergedListFile

echo "加载最新的定时任务文件..."
crontab $mergedListFile
