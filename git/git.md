## git 清空所有commit记录方法
```
说明：例如将代码提交到git仓库，将一些敏感信息提交，所以需要删除提交记录以彻底清除提交信息，以得到一个干净的仓库且代码不变

```
#### 1.Checkout
```
$ git checkout --orphan latest_branch
```
#### 2. Add all the files
```
$ git add -A
```
#### 3. Commit the changes
```
$ git commit -am "commit message"
```
#### 4. Delete the branch
```
$ git branch -D master
```
#### 5.Rename the current branch to master
```
$ git branch -m master
```
#### 6.Finally, force update your repository
```
git push -f origin master
```
## git 主干和分支同步

#### 1、远程分支
```
查看当前的远程分支
$ git remote -v
```
#### 2、增加远程分支
```
$ git remote add latest https://github.com/xxlaila/work.git
```
#### 3、更新主库的远程分支
```
更新远程分支
$ git fetch latest
```
#### 4、合并主库的最新代码
```
合并主库的最新代码
$ git rebase latest/dev
```
#### 5、推送本地代码到自身远程仓库
```
推送远程仓库
$ git push
```
