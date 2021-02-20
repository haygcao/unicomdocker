autoSign:
  image: akyakya/autosign:latest
  container_name: autosign
  restart: always
  tty: true
  volumes:
    - ./cookies:/root/.AutoSignMachine
    - ./logs:/AutoSignMachine/logs
  environment:
    - ENABLE_UNICOM=True
    - UNICOM_CONFIG=/root/.AutoSignMachine/unicom.json #多账号配置json需要放在本地cookies文件夹里挂载到容器的/root/.AutoSignMachine文件件
    - UNICOM_PHONE=18*******5
    - UNICOM_PWD=9****5
    - UNICOM_APPID=1f7af72a********8808a045
    - ENABLE_BILIBILI=True
    - BILIBILI_ACCOUNT=e*******@gmail.com
    - BILIBILI_PWD=p******s
    - ENABLE_52POJIE=True
    - htVD_2132_auth=d9bdYfS*********ojcyLOu
    - htVD_2132_saltkey=M*******3
