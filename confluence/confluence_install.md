# confluence 6.12.2 破解版安装

## 安装mysql 5.7.24 版本
### 安装mysql
```
# rpm -ivh http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
# yum list |grep "mysql"
# yum install -y mysql-community-server
```
- 启动mysql
```
# systemctl start mysqld.service
# systemctl enable mysqld.service
```
- 修改myslq密码
```
# grep 'temporary password' /var/log/mysqld.log
mysql> SET PASSWORD = PASSWORD('news password');
mysql> ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;
mysql> flush privileges;
```
### 修改mysql的配置文件，用于支持confluence的最低安装需求
- 在my.cnf配置文件[mysqld]里面添加下面配置参数
- 将默认字符集指定为UTF-8
```
character-set-server=utf8
collation-server=utf8_bin
```
- 将默认存储引擎设置为InnoDB：
```
default-storage-engine=INNODB
```
- 指定值max_allowed_packet至少为256M
```
max_allowed_packet=512M
```
- 指定值  innodb_log_file_size 至少为2GB
```
innodb_log_file_size=2GB
```
- 确保数据库的全局事务隔离级别已设置为READ-COMMITTED
```
transaction-isolation=READ-COMMITTED
```
- 检查二进制日志记录格式是否配置为使用“基于行”的二进制日志记录
```
binlog_format=row
```
- 确保sql_mode参数未指定NO_AUTO_VALUE_ON_ZERO
```
sql_mode = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
```
- 重启mysql数据库
### 为Confluence创建数据库用户和数据库
```
mysql> CREATE DATABASE confluence CHARACTER SET utf8 COLLATE utf8_bin;
mysql> GRANT ALL PRIVILEGES ON confluence.* TO confluence@'localhost' IDENTIFIED BY 'password'
mysql> flush privileges;
```
## 安装Confluence
- 下载Confluence，这里下载bin文件进行安装，下载地址：https://www.atlassian.com/software/confluence/download-archives
- 下载的版本为atlassian-confluence-6.12.2-x64.bin,包有点大，需要等待
- 赋予权限
```
# chmod a+x atlassian-confluence-6.12.2-x64.bin
```
- 开始安装
```
# ./atlassian-confluence-6.12.2-x64.bin
```
- 安装过程中需要做一些基本的配置，详情查看我的配置
```
Unpacking JRE ...
Starting Installer ...

This will install Confluence 6.12.2 on your computer.
OK [o, Enter], Cancel [c]
o （输入o同意）
Click Next to continue, or Cancel to exit Setup.

Choose the appropriate installation or upgrade option.
Please choose one of the following:
Express Install (uses default settings) [1], 
Custom Install (recommended for advanced users) [2, Enter], 
Upgrade an existing Confluence installation [3]
2   (选择2自定义安装，我们可以进行一些定制的配置)
```
- 开始进行安装参数的配置
```
Select the folder where you would like Confluence 6.12.2 to be installed,
then click Next.
Where should Confluence 6.12.2 be installed?
[/opt/atlassian/confluence](安装目录,目录变化可以在这里输入，这里直接回车)

Default location for Confluence data
[/var/atlassian/application-data/confluence]（数据的存放目录，这里我们修改到我们的数据盘）
/opt/atlassian/confluence-data/

Configure which ports Confluence will use.
Confluence requires two TCP ports that are not being used by any other
applications on this machine. The HTTP port is where you will access
Confluence through your browser. The Control port is used to Startup and
Shutdown Confluence.
Use default ports (HTTP: 8090, Control: 8000) - Recommended [1, Enter], Set custom value for HTTP and Control ports [2]
（这里是设置使用的端口，默认即可）

Confluence can be run in the background.
You may choose to run Confluence as a service, which means it will start
automatically whenever the computer restarts.
Install Confluence as Service?
Yes [y, Enter], No [n]
y

Extracting files ...
                                                                           

Please wait a few moments while we configure Confluence.

Installation of Confluence 6.12.2 is complete
Start Confluence now?
Yes [y, Enter], No [n]
y

Please wait a few moments while Confluence starts up.
Launching Confluence ...
输入y回车后Confluence会进行后台安装，这里等待安装完成即可

Installation of Confluence 6.12.2 is complete
Your installation of Confluence 6.12.2 is now ready and can be accessed via
your browser.
Confluence 6.12.2 can be accessed at http://localhost:8090
安装完成
```
- 通过浏览器访问试一下
![images]

### 安装nginx 进行方向代理访问
```
# rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
# yum install nginx -y
# systemctl start nginx.service
# systemctl enable nginx.service
配置nginx的upstream这里将不再阐述
```
### 接下来通过浏览器进行配置
- 打开页面
![image](https://github.com/xxlaila/work/blob/master/img/5DF0B5DCC39B66AC87133FB0260A6CD8.jpg)
- 设置语言为中文和产品安装
![image](https://github.com/xxlaila/work/blob/master/img/23095BDB546CAE356E8B04E252BCFC9E.jpg)
- 生成授权码
![image](https://github.com/xxlaila/work/blob/master/img/CB99372F30342EBABC1125510FBC50B9.jpg)
```
# /etc/init.d/confluence stop
```
### 破解Confluence
- 在本地下载破解器
```
# wget https://github.com/xxlaila/work/blob/master/zip/confluence.zip
# unzip confluence.zip
```
- 在服务器上把atlassian-extras-decoder-v2-3.4.1.jar进行如下操作
```
# cd /opt/atlassian/confluence/confluence/WEB-INF/lib
# cp atlassian-extras-decoder-v2-3.4.1.jar /opt/atlassian-extras-2.4.jar
# mv atlassian-extras-decoder-v2-3.4.1.jar atlassian-extras-decoder-v2-3.4.1.jar.bak
```
- 把/opt/atlassian-extras-2.4.jar下载到本地
- 本地启动Confluence破解器
```
$ java -jar confluence_keygen.jar
```
- 点击.patch! 选择下载到本地的atlassian-extras-2.4.jar包，文件类型不变，点击打开，自动生产一个新的atlassian-extras-2.4.jar包
![image](https://github.com/xxlaila/work/blob/master/img/FA8682F205BB1655E20AAD392DF13417.jpg)
- 把服务器id输入到server id，name项随便输入，名称不要过短，店家.gen!生成授权吗，然后把授权复制到confluence框里面
- 把新生成的包上传到/opt/atlassian/confluence/confluence/WEB-INF/lib/目录下面
```
### 下载mysql驱动