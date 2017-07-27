[![Build Status](https://travis-ci.org/sqshq/PiggyMetrics.svg?branch=master)](https://travis-ci.org/sqshq/PiggyMetrics)
[![codecov.io](https://codecov.io/github/sqshq/PiggyMetrics/coverage.svg?branch=master)](https://codecov.io/github/sqshq/PiggyMetrics?branch=master)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/sqshq/PiggyMetrics/blob/master/LICENCE)
[![Join the chat at https://gitter.im/sqshq/PiggyMetrics](https://badges.gitter.im/sqshq/PiggyMetrics.svg)](https://gitter.im/sqshq/PiggyMetrics?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Piggy Metrics

**一种管理个人财务状况的简单方法**?

这是一个 概念验证型（[proof-of-concept](http://my-piggymetrics.rhcloud.com)）应用，通过使用Spring Boot, Spring Cloud 和 Docker，用简洁的用户界面对微服务体系模式（[Microservice Architecture Pattern](http://martinfowler.com/microservices/)）进行论证和呈现。


![](https://cloud.githubusercontent.com/assets/6069066/13864234/442d6faa-ecb9-11e5-9929-34a9539acde0.png)
![Piggy Metrics](https://cloud.githubusercontent.com/assets/6069066/13830155/572e7552-ebe4-11e5-918f-637a49dff9a2.gif)

## 功能服务

PiggyMetrics可以被分解成三个核心的微服务。这三个微服务是独立部署的应用，围绕特定的业务能力进行组织。

<img width="880" alt="Functional services" src="https://cloud.githubusercontent.com/assets/6069066/13900465/730f2922-ee20-11e5-8df0-e7b51c668847.png">

#### 帐户服务
包括常规的用户输入逻辑和校验：个人收益/开支明细、存款和账户设置。

Method	| Path	| Description	| User authenticated	| Available from UI
------------- | ------------------------- | ------------- |:-------------:|:----------------:|
GET	| /accounts/{account}	| 获取指定账户数据	|  | 	
GET	| /accounts/current	| 获取当前账户数据	| × | ×
GET	| /accounts/demo	| 获取演示账户数据（例如预先输入的收益/开支明细）	| ? | 	×
PUT	| /accounts/current	| 保存当前账户数据	| × | ×
POST	| /accounts/	| 注册新账户	| ? | ×


#### 统计服务
在主要的统计参数和获取时间序列方面为每个账户执行统计操作。数据点包括标准化后的基础货币、时间序列等值。这些数据可用于在账户生命周期内动态的跟踪现金流。（用户界面中暂未实现绚丽的图标分析）

Method	| Path	| Description	| User authenticated	| Available from UI
------------- | ------------------------- | ------------- |:-------------:|:----------------:|
GET	| /statistics/{account}	| 获取指定账户统计数据 |  | 	
GET	| /statistics/current	| 获取当前账户统计数据	| × | × 
GET	| /statistics/demo	| 获取演示账户统计数据	| ? | × 
PUT	| /statistics/{account}	| 创建或更新指定账户的具体时间元数据	| ? | 


#### 通知服务
存储用户联系信息和通知设置（比如提醒周期和备份周期），根据预定的计划从其他微服务收集必要的信息并发送给订阅客户。

Method	| Path	| Description	| User authenticated	| Available from UI
------------- | ------------------------- | ------------- |:-------------:|:----------------:|
GET	| /notifications/settings/current	| 获取当前账户通知设置信息	| × | ×	
PUT	| /notifications/settings/current	| 保存当前通知设置信息	| × | ×

#### Notes
- 每个微服务都有自己的数据库，不使用API将无法直接访问持久化数据。
- 本工程中，我使用MongoDB?作为每个微服务的主数据库。也许支持多种持久性结构显得更有意义（可选择数据库的类型是服务最适合的方式）。
- 服务之间的通讯非常简单：微服务只使用同步的REST API进行通信。现实情况中，常见的做法是结合使用不同的交互方式。例如：为了解耦服务和缓存消息，GET操作中一般使用同步的方式请求和获取数据；而在创建和更新操作中则通过消息代理实现异步处理。这些方法将达成最终一致（[eventual consistency](http://martinfowler.com/articles/microservice-trade-offs.html#consistency)）的目标。


## 基础设施服务
分布式系统中存在大量的公共模式，它们可以帮助我们专注于核心的服务实现。[Spring cloud](http://projects.spring.io/spring-cloud/)提供了一系列强有力的工具增强了Spring Boot应用，使得上述公共模式得以实现。我将简要介绍它们。

<img width="880" alt="Infrastructure services" src="https://cloud.githubusercontent.com/assets/6069066/13906840/365c0d94-eefa-11e5-90ad-9d74804ca412.png">
### Config service
[Spring Cloud Config](http://cloud.spring.io/spring-cloud-config/spring-cloud-config.html) 是为分布式系统提供的水平可伸缩的集中配置服务。它使用一个可插入的仓库层,目前支持本地存储,Git和Subversion。

本项目中,我使用可轻松加载到本地classpath中的 `native profile`。你可以在 [Config service resources](https://github.com/sqshq/PiggyMetrics/tree/master/config/src/main/resources)中看到共享目录。当通知服务发起访问自身配置的请求时,?Config service以`shared/notification-service.yml`?和`shared/application.yml`文件的方式进行响应（在所有客户端程序中共享）。


##### 客户端使用
通过`spring-cloud-starter-config`依赖构建?Spring Boot应用，剩下的部分将会自动构建。

在`bootstrap.yml`中定义好应用的名称和Config service 的url后，你的应用中将不再需要任何内置的配置文件。

```yml
spring:
  application:
    name: notification-service
  cloud:
    config:
      uri: http://config:8888
      fail-fast: true
```

##### 使用Spring Cloud Config，您可以动态更改应用配置。 
例如，[EmailService bean](https://github.com/sqshq/PiggyMetrics/blob/master/notification-service/src/main/java/com/piggymetrics/notification/service/EmailServiceImpl.java)用`@RefreshScope`注释，这意味着您可以在不重新编译和重启通知服务应用的情况下，更改电子邮件文本和主题。


首先，在Config服务器中更改所需的属性。然后，对Notification服务执行刷新请求:
`curl -H "Authorization: Bearer #token#" -XPOST http://127.0.0.1:8000/notifications/refresh`

此外，您可以使用webhooks库自动执行此过程 [webhooks to automate this process](http://cloud.spring.io/spring-cloud-config/spring-cloud-config.html#_push_notifications_and_spring_cloud_bus)

##### 说明
- 动态刷新仍然有一些限制。注解 `@RefreshScope` 不能与`@Configuration`在类中一起使用，并且在 `@Scheduled`注解的方法中不起作用。
- 如果它无法连接到Config Service，fail-fast属性意味着Spring Boot应用程序将立即失败启动。这在[启动所有应用程序](https://github.com/sqshq/PiggyMetrics#how-to-run-all-the-things)时非常有用。 
- 下面是一些重要的[安全说明](https://github.com/sqshq/PiggyMetrics#security)


### 授权服务
授权责任完全抽取到单独的服务器，它为后端资源服务授予[OAuth2 tokens](https://tools.ietf.org/html/rfc6749)令牌。授权服务器在边界内为用户授权提供安全的机对机通讯。

本项目中，我使用密码凭据类型（[`Password credentials`](https://tools.ietf.org/html/rfc6749#section-4.3) ）实现用户授权（因为它仅由本地PiggyMetrics UI使用），使用客户端凭证（[`Client Credentials`](https://tools.ietf.org/html/rfc6749#section-4.4)）实现微服务授权。

Spring Cloud Security提供了方便的注释和自动配置，使得从服务器端和客户端都很容易实现。您可以在[文档](http://cloud.spring.io/spring-cloud-security/spring-cloud-security.html) 中了解更多信息，并在[Auth Server代码](https://github.com/sqshq/PiggyMetrics/tree/master/auth-service/src/main/java/com/piggymetrics/auth)中检查配置详细信息。

就客户端而言，一切工作与传统的基于会话的授权相同。您可以从请求中检索`Principal`对象，通过基于表达式的访问控制和`@PreAuthorize`注解检查用户的角色和其他内容。


PiggyMetrics中的每个客户端（帐户服务，统计服务，通知服务和浏览器）都有一个范围：服务器用于后端服务，ui  - 用于浏览器。因此，我们还可以保护控制器免受外部访问，例如：

``` java
@PreAuthorize("#oauth2.hasScope('server')")
@RequestMapping(value = "accounts/{name}", method = RequestMethod.GET)
public List<DataPoint> getStatisticsByAccountName(@PathVariable String name) {
	return statisticsService.findByAccountName(name);
}
```

### API网关
可以看到，有三个核心服务向客户端公开外部API。现实系统中，这个数字随着系统的复杂性增加将会快速增长。实际上，可能数百种服务都会参与渲染某个复杂网页。

理论上，客户端可以直接向每个微服务器发出请求。但很显然，在类似需要知道所有端点地址，分别执行每一个分离的http请求，并且在客户端合并结果数据方面，这种方式存在相当的挑战和限制。另一个问题是网络友好协议可能在后端使用。

更好的方法是使用API网关。它是进入系统的单一入口，通过路由将请求分发到恰当的后端服务或直接调用多个后端服务进行处理，[并将结果进行聚合](http://techblog.netflix.com/2013/01/optimizing-netflix-api.html)。此外，它可用于身份验证，insights，压力测试和canary?测试，服务迁移，静态响应处理，主动流量管理等。

Netflix开源了一个[边界服务](http://techblog.netflix.com/2013/06/announcing-zuul-edge-service-in-cloud.html)，在Spring Cloud中我们可以用一个@EnableZuulProxy 注解使用它。在这个项目中，我使用Zuul来存储静态内容（ui应用程序）并且将请求路由到适当的微服务。以下是一个通知服务中基于前缀的简单路由配置：


```yml
zuul:
  routes:
    notification-service:
        path: /notifications/**
        serviceId: notification-service
        stripPrefix: false

```

这意味着所有以/ notifications开头的请求都将路由到通知服务。你可以看到这里并没有硬编码的地址。Zuul使用服务发现机制( [Service discovery](https://github.com/sqshq/PiggyMetrics/blob/master/README.md#service-discovery))来定位通知服务实例、断路器以及负载平衡器，以下将进行阐述。


### 服务发现
另一个公知的架构模式是服务发现。它允许自动检测服务实例的网络位置，由于自动扩展，故障和升级，可能会动态分配地址。

服务发现的关键部分是注册。我在这个项目中使用Netflix Eureka。当客户端负责决定可用的服务实例（使用注册表服务器）的位置和加载负载均衡请求时，Eureka是客户端发现模式的一个很好的例子。

Spring Boot中，您可以轻松地使用spring-cloud-starter-eureka-server依赖，@EnableEurekaServer注解和简单的配置属性来构建Eureka 注册。

客户端支持在bootstrap.yml中使用@EnableDiscoveryClient注解，以应用名识别：

``` yml
spring:
  application:
    name: notification-service
```

现在，在应用程序启动时，它将注册到Eureka服务器并提供元数据，如主机和端口，健康指示器URL，主页等。Eureka从属于一个服务的每个实例接收心跳消息。如果在可配置的时间表发生心跳故障，则实例将从注册表中删除。

此外，Eureka提供了一个简单的界面，您可以跟踪运行的服务和可用实例数：

`http://localhost:8761`

### 负载均衡器，断路器和Http客户端

Netflix OSS提供了一系列强大的工具集。 

#### Ribbon
Ribbon是一个可以对HTTP和TCP客户端的行为进行控制客户端负载均衡器。与传统的负载均衡器相比，Ribbon无需对每个线上调用都处理心跳，您可以直接访问所需的服务。

它与Spring Cloud和服务发现本身集成，因此可开箱即用。 [Eureka Client](https://github.com/sqshq/PiggyMetrics#service-discovery)提供了可用服务器的动态列表，以便Ribbon可以在它们之间进行平衡。


#### Hystrix
Hystrix是断路器模式（[Circuit Breaker pattern](http://martinfowler.com/bliki/CircuitBreaker.html)）的实现，它提供了对通过网络访问的依赖性的延迟和故障的控制。主要实现思路是在具有大量微服务的分布式环境中停止级联故障。在容错系统的自我治愈方面，它帮助错误尽可能的快速发现并且恢复。

除了断路器控制，使用Hystrix，您可以添加一个后备方法，在主命令失败的情况下调用该方法以获取默认值。

此外，Hystrix生成每个命令的执行结果和延迟的指标，我们可以用它来监视系统行为（[monitor system behavior](https://github.com/sqshq/PiggyMetrics#monitor-dashboard)）。


#### Feign

Feign是一个与Ribbon和Hystrix无缝集成的声明式Http客户端。实际上，使用一个`spring-cloud-starter-feign`依赖和`@EnableFeignClients`注解，您拥有一组完整的负载均衡器，断路器和Http客户端以及合理的即用型默认配置。
以下是帐户服务的示例：


你需要的只是一个接口：?

``` java
@FeignClient(name = "statistics-service")
public interface StatisticsServiceClient {

	@RequestMapping(method = RequestMethod.PUT, value = "/statistics/{accountName}", consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
	void updateStatistics(@PathVariable("accountName") String accountName, Account account);

}
```

- 你需要的只是一个接口
-?你可以在Spring MVC控制器和Feign方法之间共享`@RequestMapping` 
- 通过Eureka自动发现，上面的示例指定只需要服务id  - 统计服务，（显然，您可以访问任何资源与特定的URL）

### 监视仪表盘?

在这个项目配置中，Hystrix的每个微服务通过Spring Cloud Bus（使用AMQP代理）将指标推送到Turbine，本项目只是与? [Turbine](https://github.com/Netflix/Turbine)?和 [Hystrix Dashboard](https://github.com/Netflix/Hystrix/tree/master/hystrix-dashboard)集成的Spring Boot应用。


 [下面看它如何运行](https://github.com/sqshq/PiggyMetrics#how-to-run-all-the-things).

让我们看看我们的系统在负载下的行为：帐户服务调用统计服务时，通过不同的模仿延迟进行响应。响应超时阈值设置为1秒。

<img width="880" src="https://cloud.githubusercontent.com/assets/6069066/14194375/d9a2dd80-f7be-11e5-8bcc-9a2fce753cfe.png">

<img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127349/21e90026-f628-11e5-83f1-60108cb33490.gif">	| <img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127348/21e6ed40-f628-11e5-9fa4-ed527bf35129.gif"> | <img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127346/21b9aaa6-f628-11e5-9bba-aaccab60fd69.gif"> | <img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127350/21eafe1c-f628-11e5-8ccd-a6b6873c046a.gif">
--- |--- |--- |--- |
| `0 ms 延迟` | `500 ms 延迟` | `800 ms 延迟` | `1100 ms 延迟`
| 系统表现良好。吞吐量约为22请求/秒。统计服务中的活动线程数较少。中位服务时间约为50 ms。 | 活动线程的数量在增加。我们可以看到紫色线程池拒绝的数量，因此约30-40％的错误，但轮询仍然关闭。 | 半开状态：故障命令的比率大于50％，断路器启动。在睡眠窗口的时间后，下一个请求被允许通过。 | 100％的请求失败。轮询现在永久打开。在睡眠时间后重试不会再次闭合轮询，因为单个请求太慢。

### 日志分析

当尝试在分布式环境中识别问题时，集中式日志记录可能非常有用。使用Elasticsearch，Logstash和Kibana stack，您可以轻松地搜索和分析您的日志、资源利用率和网络活动数据。可以从我的其他项目[ my other project](http://github.com/sqshq/ELK-docker)中了解Docker配置。



## 安全性

高级安全配置超出了此概念验证项目的范围。在更真实的模拟系统中，考虑使用https，JCE密钥库加密微服务密码和配置服务器属性内容（有关详细信息，请参阅[文档](http://cloud.spring.io/spring-cloud-config/spring-cloud-config.html#_security)）

## 基础架构自动化

相比部署单个的应用程序，部署微服务及其相互依赖性要复杂得多，拥有完全自动化的基础架构显得非常重要。我们可以通过持续交付方法获得以下益处：

- 随时发布软件版本的能力
- 任何构建结束都可以发布
- 一次构建- 根据需要部署 

这个项目中实现了一个简单的持续交付工作流：

<img width="880" src="https://cloud.githubusercontent.com/assets/6069066/14159789/0dd7a7ce-f6e9-11e5-9fbb-a7fe0f4431e3.png">

在此配置中( [configuration](https://github.com/sqshq/PiggyMetrics/blob/master/.travis.yml))，Travis CI为每个成功的git push建立标记的镜像。因此，对于Docker Hub和旧镜像上的每个微服务，始终有最新的镜像，它们都用git commit hash进行标记。如果需要，快速部署或回滚任何一个镜像将会变得简单。

## 如何运行所有环境?

记住，你要启动8个Spring Boot应用程序，4个MongoDB实例和RabbitMq。确保您的机器上有4 Gb RAM可用。您可以始终运行重要的服务：网关，注册，配置，认证服务和帐户服务。

#### 在你开始之前
- 安装 Docker and Docker Compose.
- 导出环境变量: `CONFIG_SERVICE_PASSWORD`, `NOTIFICATION_SERVICE_PASSWORD`, `STATISTICS_SERVICE_PASSWORD`, `ACCOUNT_SERVICE_PASSWORD`, `MONGODB_PASSWORD`

#### 生产模式
在这种模式下，所有最新的镜像将从Docker Hub中提取。只需复制 `docker-compose.yml`并且执行 `docker-compose up -d`。?

#### 开发模式
如果你想自己构建镜像（例如在代码中有一些变化），建议你使用maven克隆所有的库和artifacts?。.然后，继承`docker-compose.yml`运行 `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d` `docker-compose.dev.yml` ，可以在本地构建映像，并开放所有容器端口以方便开发。

#### 重要节点
- http://DOCKER-HOST:80 - Gateway
- http://DOCKER-HOST:8761 - Eureka Dashboard
- http://DOCKER-HOST:9000/hystrix - Hystrix Dashboard
- http://DOCKER-HOST:8989 - Turbine stream (source for the Hystrix Dashboard)
- http://DOCKER-HOST:15672 - RabbitMq 管理 (default login/password: guest/guest)

#### 说明
所有Spring Boot应用程序都需要运行[Config Server](https://github.com/sqshq/PiggyMetrics#config-service)进行启动。因为使用了`fail-fast` Spring Boot属性和`restart: always`?docker-compose?选项，我们可以同时启动所有容器。
这意味着在Config Server启动并运行之前，所有依赖的容器将尝试重新启动。

此外，服务发现机制需要在所有应用程序启动后一段时间才能生效。在实例，Eureka服务器和客户端都在其本地缓存中具有相同的元数据前，服务发现机制将不可用。因此，它可能需要3次心跳。默认心跳周期为30秒。

## 欢迎反馈

PiggyMetrics是开源的，非常期望和感谢您的帮助。随时与我联系任何问题。
