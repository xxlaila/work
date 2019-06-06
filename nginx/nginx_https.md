## nginx http 强制跳转到https

### 方法一
```
if ($scheme = http ) {
    return 301 https://$host$request_uri;
}
```
#### 列子
```
server {
    listen 80;
    listen 443;
    server_name xxx.test.com;
    index index.html index.php index.htm;
    if ($scheme = http ) {
        return 301 https://$host$request_uri;
    }
}
```
### 方法二
```
if ($server_port = 80 ) {
    return 301 https://$host$request_uri;
}
```
#### 列子
```
server {
    listen 80;
    listen 443;
    server_name xxx.test.com;
    index index.html index.php index.htm;
    if ($server_port = 80 ) {
        return 301 https://$host$request_uri;
    }
}
```
### 方法三
```
if ($ssl_protocol = "") { return 301 https://$server_name$request_uri; }
if ($host != xxx.test.com) { return 301 $scheme://xxx.test.com$request_uri; }
```
#### 列子
```
server {
    listen 80;
    listen 443;
    server_name xxx.test.com;
    index index.html index.php index.htm;
    if ($ssl_protocol = "") { return 301 https://$server_name$request_uri; }
    if ($host != xxx.test.com) { return 301 $scheme://xxx.test.com$request_uri; }
}
```
### 方法四
```
server {
    listen 80;
    server_name test.com www.test.com;
    rewrite ^(.*) https://www.test.com$1 permanent;
}
```
#### 例子
```
server {
    listen 80;
    server_name test.com www.test.com;
    rewrite ^(.*) https://www.test.com$1 permanent;
}
server {
    listen 443;
    server_name test.com www.test.com;
    index index.html index.htm index.php;
    root ;
}
```
### 方法五
```
server {
    listen 80;
    server_name test.com www.test.com;
    return 301 https://$server_name$request_uri;
}
```
