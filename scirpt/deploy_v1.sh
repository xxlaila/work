#!/bin/bash
checkResult=0
timeout=0
project_list=$1
env=$2
version=$3
if [ $# -ne 3 ];then
  echo "变量不正确，请检查"
fi
# 检测md5
function codeCheckMD5()
{
        md5FilePre=$1
        md5FileSec=$2
        md5Value1="default1"
        md5Value2="default2"
        if [[ "$md5FilePre" == *.tar.gz ]];then
                md5Value1=`sudo md5sum ${md5FilePre}|cut -d " " -f1`
        else
                md5Value1=`sudo cat ${md5FileSec}`
        fi
        if [[ "$2" == *.tar.gz ]];then
                md5Value2=`sudo md5sum ${md5FilePre}|cut -d " " -f1`
        else
                md5Value2=`sudo cat ${md5FileSec}`
        fi
}
# 等待30秒
function cycle(){
while [[ ${checkResult} -eq 0 ]]
do
        if [[ ${timeout} -lt 6 ]];then
                timeout=$[timeout+1]
                echo "INFO: Wait file upload $[timeout*5] s..."
                sleep 5
                detect
        else
                echo "ERROR: Wait file upload timeout 30 s!"
                exit 1
        fi
done
}
# 代码部署
function deploy()
{
        group_vars=$(python /etc/ansible/dy_inventories/get_group_vars.py -p ${ProjectName} -e ${env}); echo $?
        if [[ "${ProjectName}" =~ "test.com" ]];then
                sudo su - otoman -c "ansible-playbook -i /etc/ansible/inventories/${env}/ /etc/ansible/portal_app.yml -e \"project_name=${ProjectName}\""
        else
                if [[ $? == 0 ]];then
                sudo su - otoman -c "/usr/bin/ansible-playbook /etc/ansible/java_app.yml -i /etc/ansible/dy_inventories/hosts_${env}.py -e \"project_name=${ProjectName}\""
                else
                sudo su - otoman -c "/usr/bin/ansible-playbook /etc/ansible/dy_java_app.yml -i /etc/ansible/dy_inventories/hosts_${env}.py -e \"project_name=${ProjectName}\" -e '${group_vars}'"
            fi
        fi
}
# copy 代码
function copyCode(){
        SourceFile=$1
        SourceMd5File=$2
        DestDir=$3
        BackupDir=$4
        if [[ -f "${DestDir}/md5" ]];then
                codeCheckMD5 ${SourceMd5File} ${DestDir}/md5
                if [[ "${md5Value}" != "true" ]];then
                        sudo cp -f ${SourceFile}  ${DestDir}
                        sudo cp -f ${SourceMd5File} ${DestDir}
                else
                        echo "ERROR: Code is not changed!"
                        exit 1
                fi
        else
                sudo mkdir -p ${DestDir}
                sudo cp -f ${SourceFile}  ${DestDir}
                sudo cp -f ${SourceMd5File} ${DestDir}
        fi
        sudo mkdir -p ${BackupDir}
        sudo cp -f ${SourceFile} ${BackupDir}
        sudo cp -f ${SourceMd5File} ${BackupDir}
        deploy
}
# 环境的检查
function CheckEnv(){
        if [[ ${env} != "uat" ]];then
                copyCode ${SourceFile}  ${SourceMd5File}  ${DestDir} ${BackupDir}
        fi
}
# 调用检测md5
function detect(){
        # File not exits.
        if [[ ! -f ${SourceMd5File} ]];then
                echo "ERROR: The file ${SourceMd5File} is not exists!"
                exit 1
        fi
        # File not exits.
        if [[ ! -f ${SourceFile} ]];then
                echo "ERROR: The file ${SourceMd5File} is not exists!"
                exit 1
        fi
        codeCheckMD5 ${SourceFile} ${SourceMd5File}
        if [[ "${md5Value1}" == "${md5Value2}" ]];then
                CheckEnv
        else
                cycle
        fi
}
# 项目名称的提取和分类
function Server(){
arr=(${project_list//,/ })
for ProjectName in ${arr[@]}
do
        if [[ $(echo ${ProjectName} |grep "test.com") != "" ]];then
                repo="node-repo"
        else
                repo="java-repo"
        fi
        Datetime=`date +'%Y%m%d%H%M%S'`
        SourceFile="/opt/code-repo/uat/${repo}/${ProjectName}/${ProjectName}.tar.gz"
        SourceMd5File="/opt/code-repo/uat/${repo}/${ProjectName}/md5"
        DestDir="/opt/code-repo/${env}/${repo}/${ProjectName}/"
        BackupDir="/data/code-backup/${env}/${repo}/${ProjectName}/${Datetime}"
        echo "update project is: "${ProjectName}
        detect
done
}
Server
