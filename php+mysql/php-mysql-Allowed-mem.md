## 环境lnmp
```
网站之前是正常的，某一天突然访问的时候提示：Allowed memory size of 268435456 bytes exhausted(tried to allocate 4 bytes)
这个错误就是一个网站一个简单的登陆就报这个错，本质上是代码问题，但是之前用的很好，没动过这个东西，不应该出现
```
![image](https://github.com/xxlaila/work/blob/master/img/Allowed-memory.png)
### 1、网上的解决办法
####1.1 修改php.ini文件的参数
```
memory_limit 修改为调整过小，出现500，加大这个参数，报错信息还是一样的,下面参数是我修改后的参数
memory_limit = 1024M
```
####1.2 在php的入口文件增加配置参数
```
在index.php这个入口文件增加这段代码：ini_set("memory_limit","120M");
还是报错，报错信息：为调整过小，出现500，加大这个参数，报错信息还是一样的
```
### 2、更换服务器
```
安装一个新的lnmp、lamp、wamp环境均不行，还是报这个错误，
新环境代码是一样的，数据库还是连接老的数据库，到这里还以为是代码问题，开发也
```
### 3、修改数据库
```
之前的办法都试过不行，尝试着吧数据库备份，然后倒入到新服务器，在新服务器倒入数据库的时候，报错了，
```
![image](https://github.com/xxlaila/work/blob/master/img/php_mysql.jpg)
### 4、比对新老数据库表的类型
#### 4.1 新老数据库查询表的数据对比
```
上面是新库的，网页打开正常，下面是老的，网页打开不正常
```
![image](https://github.com/xxlaila/work/blob/master/img/php-ta.png)
#### 4.2 对比两个数据库的表结构
```
左边是新数据库的表，右边是老数据库的表
````
![image](https://github.com/xxlaila/work/blob/master/img/php-tables.png)
### 5、查询mysql的该参数
```
在网上查询mysql的这个参数使用场景和应用类型，然后吧该情况反应给开发，开发对数据库表，代码都做修改。
本次问题，数据库字段类型，插入的数据错误导致的，至于逻辑，php不懂
```
