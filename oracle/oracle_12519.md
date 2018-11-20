## oracle ORA-12519错误解决 
### 1、今天遇到做系统压力测试的时候，系统报了一个错误
```
OERR: ORA-12519 TNS:no appropriate service handler found
```
![image](https://github.com/xxlaila/work/blob/master/img/ORA-12519-error.png)
### 2、在网上搜索了一下oralc的错误信息ORA-12519，解决办法挺多的，这里记录一下
### 3、登陆oracle的服务器，在登陆oracle数据库
sqlplus "/as sysdba"
### 4、首先检查process和session的使用情况
![image](https://github.com/xxlaila/work/blob/master/img/parameter_%20processes_1.png)
![image](https://github.com/xxlaila/work/blob/master/img/parameter_%20session_1.png)
```
这里可以看到process几乎已经满了
```
### 5、修改oracle的process和session值
```
这里我们把这些值修改为1000和1135
SQL> alter system set processes=1000 scope=spfile;
系统已更改。
SQL> alter system set sessions=1135 scope=spfile;
系统已更改。
```
### 6、重启数据库后参数修改完成
```
SQL> shutdown abort;
ORACLE 例程已经关闭。
SQL> startup;
ORACLE 例程已经启动。
Total System Global Area  534462464 bytes
Fixed Size                  2215064 bytes
Variable Size             234881896 bytes
Database Buffers          289406976 bytes
Redo Buffers                7958528 bytes
数据库装载完毕。
数据库已经打开。
```
### 7、查看并验证
![image](https://github.com/xxlaila/work/blob/master/img/W.png)
