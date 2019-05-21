## mysql 数据库服务器修改字符集为utf8mb4

###1、修改mysql默认的字符集，/etc/my.cnf
```
cat /etc/my.cnf
[client]
default-character-set = utf8mb4
[mysqld]
character-set-client-handshake = FALSE
character_set_server = utf8mb4
collation-server = utf8mb4_unicode_ci
[mysql]
default-character-set = utf8mb4
```
## 修改已有数据库的字符集
###1、查询数据库不等于utf8mb4_unicode_ci
```
SELECT * FROM information_schema.`SCHEMATA` WHERE DEFAULT_COLLATION_NAME<>'utf8mb4_unicode_ci';
```

