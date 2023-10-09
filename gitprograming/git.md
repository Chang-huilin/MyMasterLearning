# 操作
## 获取所有分支

    PS C:\github\MyMasterLearning> git branch

    * main
## 新建分支learning   

    PS C:\github\MyMasterLearning> git checkout -b learning

    Switched to a new branch 'learning'

## 新分支 
    PS C:\github\MyMasterLearning> git branch
    *learning
    main
## 切换分支
    git checkout main
    //或者
    git switch main
## 向分支添加改动及改动说明learing
    PS C:\github\MyMasterLearning> git add .
    PS C:\github\MyMasterLearning> git commit -m'learing'
    [learning 7322069] learing
    1 file changed, 2 insertions(+), 2 deletions(-)
## 上传改动    
    PS C:\github\MyMasterLearning> git push -u origin learning
    Enumerating objects: 11, done.
    Counting objects: 100% (11/11), done.
    Delta compression using up to 20 threads
    Compressing objects: 100% (9/9), done.
    Writing objects: 100% (9/9), 1.10 KiB | 1.10 MiB/s, done.
    Total 9 (delta 3), reused 0 (delta 0), pack-reused 0
    remote: Resolving deltas: 100% (3/3), completed with 1 local object.
    remote: 
    remote: Create a pull request for 'learning' on GitHub by visiting:
    remote:      https://github.com/Chang-huilin/MyMasterLearning/pull/new/learning
    remote:
    To github.com:Chang-huilin/MyMasterLearning.git
    * [new branch]      learning -> learning
    branch 'learning' set up to track 'origin/learning'.
## 关联到远程库
