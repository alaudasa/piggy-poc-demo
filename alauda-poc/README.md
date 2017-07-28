### 说明

该文档描述如何将此项目应用于纯私有化POC部署演示。

### 前提

针对没有外部网络的私有环境，默认情况下，你需要部署gitlab，以及在自己的仓库中添加导入镜像：

* java_8-jre              - 镜像地址：java:8-jre（docker hub）
* maven                   - 镜像地址：index.alauda.cn/alaudaorg/maven-piggy
* mongodb              - 镜像地址：mongo:3 (docker hub)
* rabbitmq_3           - 镜像地址：index.alauda.cn/alaudaorg/rabbitmq:3-management

### 修改Dockerfile和alaudaci.yaml

在每一个项目中，包含镜像编译行为定义文件**alaudaci.yaml**和镜像编译文件**Dockerfile.yaml**文件，需要将其中的基础镜像地址改为你所处环境的镜像地址。一个快捷的修改方法是使用以下Shell命令，将镜像地址更改为你的的镜像地址：

```shell
find ./ ! -path ./mongodb/Dockerfile    \
-name "Dockerfile"                      \
-exec sed -i '/^FROM/ s/^.*$/FROM '"<镜像仓库地址>"'\/alauda-poc\/java:8-jre/' {} \;

find ./ -name "alaudaci.yml"    \
-exec sed -i '/^\s\+image.*$/ s/\(\s\+image: \).*/\1'"<镜像仓库地址>\/alauda-poc\/maven-piggy"'/g' {} \;
```

#### 生成的配置，以auth-service为例

编译行为定义：*Dockerfile*

```
FROM 10.0.0.6:5000/alauda-poc/java:8-jre
MAINTAINER Alexander Lukyanchikov <sqshq@sqshq.com>

ADD ./target/auth-service.jar /app/
CMD ["java", "-Xmx200m", "-jar", "/app/auth-service.jar"]

EXPOSE 5000
```

构建行为定义：*alaudaci.yaml*

```
version: "0.1.0"
pre_ci_boot:
 image: 10.0.0.6:5000/alauda-poc/maven-piggy
 tag: "latest"
ci:
 - cd auth-service
 - mvn -o package -Dmaven.test.skip=true
 - cp -ar ../auth-service $ALAUDACI_DEST_DIR
```

### 创建构建项目

你可以在灵雀云平台中手动创建这一系列服务的构建项目和相应的应用模版，然后构建出镜像，并运行完整的应用，脚本*create_build_cfg.bash*实现了自动批量创建构建项目，你可以修改*poc-cfg.sh*，然后执行piggymetrics.bash来调用，创建的服务包括：

    auth-service
    notification-service
    monitoring
    statistics-service
    account-service
    gateway
    registry
    config
#### 运行项目

在灵雀云平台中，通过生成的应用模版直接创建应用即可。

### 附：脚本修改并提交到Gitlab的Shell脚本

针对*installgitlabv2*部署包部署的gitlab。

```shell
private_token=$(
curl -s -L -X POST \
"http://localhost:9999/api/v3/session?login=root&password=alauda1234" |\
grep -Po '(?<="private_token":")[^"]*'
)
PUSH::piggymetrics() {
    #create_project
    curl --header "PRIVATE-TOKEN: $private_token" -X POST \
         "http://localhost:9999/api/v3/projects?name=piggymetrics&description='Microservice%20Architecture%20with%20Spring%20Boot,%20Spring%20Cloud%20and%20Docker%20http://my-piggymetrics.rhcloud.com/'&public=true"
    #push
    cd /opt
    git clone ssh://git@localhost:10022/root/piggymetrics.git
    cd /opt/piggymetrics
    \cp -ar /srcpush/piggymetrics/* ./
    git add *
    git commit -a -m"`date`" > /dev/null
    git push origin master > /dev/null
}
PUSH::piggymetrics
```

