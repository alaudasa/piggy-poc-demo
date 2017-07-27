[![Build Status](https://travis-ci.org/sqshq/PiggyMetrics.svg?branch=master)](https://travis-ci.org/sqshq/PiggyMetrics)
[![codecov.io](https://codecov.io/github/sqshq/PiggyMetrics/coverage.svg?branch=master)](https://codecov.io/github/sqshq/PiggyMetrics?branch=master)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/sqshq/PiggyMetrics/blob/master/LICENCE)
[![Join the chat at https://gitter.im/sqshq/PiggyMetrics](https://badges.gitter.im/sqshq/PiggyMetrics.svg)](https://gitter.im/sqshq/PiggyMetrics?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Piggy Metrics

**һ�ֹ�����˲���״���ļ򵥷���**?

����һ�� ������֤�ͣ�[proof-of-concept](http://my-piggymetrics.rhcloud.com)��Ӧ�ã�ͨ��ʹ��Spring Boot, Spring Cloud �� Docker���ü����û������΢������ϵģʽ��[Microservice Architecture Pattern](http://martinfowler.com/microservices/)��������֤�ͳ��֡�


![](https://cloud.githubusercontent.com/assets/6069066/13864234/442d6faa-ecb9-11e5-9929-34a9539acde0.png)
![Piggy Metrics](https://cloud.githubusercontent.com/assets/6069066/13830155/572e7552-ebe4-11e5-918f-637a49dff9a2.gif)

## ���ܷ���

PiggyMetrics���Ա��ֽ���������ĵ�΢����������΢�����Ƕ��������Ӧ�ã�Χ���ض���ҵ������������֯��

<img width="880" alt="Functional services" src="https://cloud.githubusercontent.com/assets/6069066/13900465/730f2922-ee20-11e5-8df0-e7b51c668847.png">

#### �ʻ�����
����������û������߼���У�飺��������/��֧��ϸ�������˻����á�

Method	| Path	| Description	| User authenticated	| Available from UI
------------- | ------------------------- | ------------- |:-------------:|:----------------:|
GET	| /accounts/{account}	| ��ȡָ���˻�����	|  | 	
GET	| /accounts/current	| ��ȡ��ǰ�˻�����	| �� | ��
GET	| /accounts/demo	| ��ȡ��ʾ�˻����ݣ�����Ԥ�����������/��֧��ϸ��	| ? | 	��
PUT	| /accounts/current	| ���浱ǰ�˻�����	| �� | ��
POST	| /accounts/	| ע�����˻�	| ? | ��


#### ͳ�Ʒ���
����Ҫ��ͳ�Ʋ����ͻ�ȡʱ�����з���Ϊÿ���˻�ִ��ͳ�Ʋ��������ݵ������׼����Ļ������ҡ�ʱ�����е�ֵ����Щ���ݿ��������˻����������ڶ�̬�ĸ����ֽ��������û���������δʵ��Ѥ����ͼ�������

Method	| Path	| Description	| User authenticated	| Available from UI
------------- | ------------------------- | ------------- |:-------------:|:----------------:|
GET	| /statistics/{account}	| ��ȡָ���˻�ͳ������ |  | 	
GET	| /statistics/current	| ��ȡ��ǰ�˻�ͳ������	| �� | �� 
GET	| /statistics/demo	| ��ȡ��ʾ�˻�ͳ������	| ? | �� 
PUT	| /statistics/{account}	| ���������ָ���˻��ľ���ʱ��Ԫ����	| ? | 


#### ֪ͨ����
�洢�û���ϵ��Ϣ��֪ͨ���ã������������ںͱ������ڣ�������Ԥ���ļƻ�������΢�����ռ���Ҫ����Ϣ�����͸����Ŀͻ���

Method	| Path	| Description	| User authenticated	| Available from UI
------------- | ------------------------- | ------------- |:-------------:|:----------------:|
GET	| /notifications/settings/current	| ��ȡ��ǰ�˻�֪ͨ������Ϣ	| �� | ��	
PUT	| /notifications/settings/current	| ���浱ǰ֪ͨ������Ϣ	| �� | ��

#### Notes
- ÿ��΢�������Լ������ݿ⣬��ʹ��API���޷�ֱ�ӷ��ʳ־û����ݡ�
- �������У���ʹ��MongoDB?��Ϊÿ��΢����������ݿ⡣Ҳ��֧�ֶ��ֳ־��Խṹ�Եø������壨��ѡ�����ݿ�������Ƿ������ʺϵķ�ʽ����
- ����֮���ͨѶ�ǳ��򵥣�΢����ֻʹ��ͬ����REST API����ͨ�š���ʵ����У������������ǽ��ʹ�ò�ͬ�Ľ�����ʽ�����磺Ϊ�˽������ͻ�����Ϣ��GET������һ��ʹ��ͬ���ķ�ʽ����ͻ�ȡ���ݣ����ڴ����͸��²�������ͨ����Ϣ����ʵ���첽������Щ�������������һ�£�[eventual consistency](http://martinfowler.com/articles/microservice-trade-offs.html#consistency)����Ŀ�ꡣ


## ������ʩ����
�ֲ�ʽϵͳ�д��ڴ����Ĺ���ģʽ�����ǿ��԰�������רע�ں��ĵķ���ʵ�֡�[Spring cloud](http://projects.spring.io/spring-cloud/)�ṩ��һϵ��ǿ�����Ĺ�����ǿ��Spring BootӦ�ã�ʹ����������ģʽ����ʵ�֡��ҽ���Ҫ�������ǡ�

<img width="880" alt="Infrastructure services" src="https://cloud.githubusercontent.com/assets/6069066/13906840/365c0d94-eefa-11e5-90ad-9d74804ca412.png">
### Config service
[Spring Cloud Config](http://cloud.spring.io/spring-cloud-config/spring-cloud-config.html) ��Ϊ�ֲ�ʽϵͳ�ṩ��ˮƽ�������ļ������÷�����ʹ��һ���ɲ���Ĳֿ��,Ŀǰ֧�ֱ��ش洢,Git��Subversion��

����Ŀ��,��ʹ�ÿ����ɼ��ص�����classpath�е� `native profile`��������� [Config service resources](https://github.com/sqshq/PiggyMetrics/tree/master/config/src/main/resources)�п�������Ŀ¼����֪ͨ����������������õ�����ʱ,?Config service��`shared/notification-service.yml`?��`shared/application.yml`�ļ��ķ�ʽ������Ӧ�������пͻ��˳����й�����


##### �ͻ���ʹ��
ͨ��`spring-cloud-starter-config`��������?Spring BootӦ�ã�ʣ�µĲ��ֽ����Զ�������

��`bootstrap.yml`�ж����Ӧ�õ����ƺ�Config service ��url�����Ӧ���н�������Ҫ�κ����õ������ļ���

```yml
spring:
  application:
    name: notification-service
  cloud:
    config:
      uri: http://config:8888
      fail-fast: true
```

##### ʹ��Spring Cloud Config�������Զ�̬����Ӧ�����á� 
���磬[EmailService bean](https://github.com/sqshq/PiggyMetrics/blob/master/notification-service/src/main/java/com/piggymetrics/notification/service/EmailServiceImpl.java)��`@RefreshScope`ע�ͣ�����ζ���������ڲ����±��������֪ͨ����Ӧ�õ�����£����ĵ����ʼ��ı������⡣


���ȣ���Config�������и�����������ԡ�Ȼ�󣬶�Notification����ִ��ˢ������:
`curl -H "Authorization: Bearer #token#" -XPOST http://127.0.0.1:8000/notifications/refresh`

���⣬������ʹ��webhooks���Զ�ִ�д˹��� [webhooks to automate this process](http://cloud.spring.io/spring-cloud-config/spring-cloud-config.html#_push_notifications_and_spring_cloud_bus)

##### ˵��
- ��̬ˢ����Ȼ��һЩ���ơ�ע�� `@RefreshScope` ������`@Configuration`������һ��ʹ�ã������� `@Scheduled`ע��ķ����в������á�
- ������޷����ӵ�Config Service��fail-fast������ζ��Spring BootӦ�ó�������ʧ������������[��������Ӧ�ó���](https://github.com/sqshq/PiggyMetrics#how-to-run-all-the-things)ʱ�ǳ����á� 
- ������һЩ��Ҫ��[��ȫ˵��](https://github.com/sqshq/PiggyMetrics#security)


### ��Ȩ����
��Ȩ������ȫ��ȡ�������ķ���������Ϊ�����Դ��������[OAuth2 tokens](https://tools.ietf.org/html/rfc6749)���ơ���Ȩ�������ڱ߽���Ϊ�û���Ȩ�ṩ��ȫ�Ļ��Ի�ͨѶ��

����Ŀ�У���ʹ������ƾ�����ͣ�[`Password credentials`](https://tools.ietf.org/html/rfc6749#section-4.3) ��ʵ���û���Ȩ����Ϊ�����ɱ���PiggyMetrics UIʹ�ã���ʹ�ÿͻ���ƾ֤��[`Client Credentials`](https://tools.ietf.org/html/rfc6749#section-4.4)��ʵ��΢������Ȩ��

Spring Cloud Security�ṩ�˷����ע�ͺ��Զ����ã�ʹ�ôӷ������˺Ϳͻ��˶�������ʵ�֡���������[�ĵ�](http://cloud.spring.io/spring-cloud-security/spring-cloud-security.html) ���˽������Ϣ������[Auth Server����](https://github.com/sqshq/PiggyMetrics/tree/master/auth-service/src/main/java/com/piggymetrics/auth)�м��������ϸ��Ϣ��

�Ϳͻ��˶��ԣ�һ�й����봫ͳ�Ļ��ڻỰ����Ȩ��ͬ�������Դ������м���`Principal`����ͨ�����ڱ��ʽ�ķ��ʿ��ƺ�`@PreAuthorize`ע�����û��Ľ�ɫ���������ݡ�


PiggyMetrics�е�ÿ���ͻ��ˣ��ʻ�����ͳ�Ʒ���֪ͨ����������������һ����Χ�����������ں�˷���ui  - �������������ˣ����ǻ����Ա��������������ⲿ���ʣ����磺

``` java
@PreAuthorize("#oauth2.hasScope('server')")
@RequestMapping(value = "accounts/{name}", method = RequestMethod.GET)
public List<DataPoint> getStatisticsByAccountName(@PathVariable String name) {
	return statisticsService.findByAccountName(name);
}
```

### API����
���Կ��������������ķ�����ͻ��˹����ⲿAPI����ʵϵͳ�У������������ϵͳ�ĸ��������ӽ������������ʵ���ϣ����������ַ��񶼻������Ⱦĳ��������ҳ��

�����ϣ��ͻ��˿���ֱ����ÿ��΢�������������󡣵�����Ȼ����������Ҫ֪�����ж˵��ַ���ֱ�ִ��ÿһ�������http���󣬲����ڿͻ��˺ϲ�������ݷ��棬���ַ�ʽ�����൱����ս�����ơ���һ�������������Ѻ�Э������ں��ʹ�á�

���õķ�����ʹ��API���ء����ǽ���ϵͳ�ĵ�һ��ڣ�ͨ��·�ɽ�����ַ���ǡ���ĺ�˷����ֱ�ӵ��ö����˷�����д���[����������оۺ�](http://techblog.netflix.com/2013/01/optimizing-netflix-api.html)�����⣬�������������֤��insights��ѹ�����Ժ�canary?���ԣ�����Ǩ�ƣ���̬��Ӧ����������������ȡ�

Netflix��Դ��һ��[�߽����](http://techblog.netflix.com/2013/06/announcing-zuul-edge-service-in-cloud.html)����Spring Cloud�����ǿ�����һ��@EnableZuulProxy ע��ʹ�������������Ŀ�У���ʹ��Zuul���洢��̬���ݣ�uiӦ�ó��򣩲��ҽ�����·�ɵ��ʵ���΢����������һ��֪ͨ�����л���ǰ׺�ļ�·�����ã�


```yml
zuul:
  routes:
    notification-service:
        path: /notifications/**
        serviceId: notification-service
        stripPrefix: false

```

����ζ��������/ notifications��ͷ�����󶼽�·�ɵ�֪ͨ��������Կ������ﲢû��Ӳ����ĵ�ַ��Zuulʹ�÷����ֻ���( [Service discovery](https://github.com/sqshq/PiggyMetrics/blob/master/README.md#service-discovery))����λ֪ͨ����ʵ������·���Լ�����ƽ���������½����в�����


### ������
��һ����֪�ļܹ�ģʽ�Ƿ����֡��������Զ�������ʵ��������λ�ã������Զ���չ�����Ϻ����������ܻᶯ̬�����ַ��

�����ֵĹؼ�������ע�ᡣ���������Ŀ��ʹ��Netflix Eureka�����ͻ��˸���������õķ���ʵ����ʹ��ע������������λ�úͼ��ظ��ؾ�������ʱ��Eureka�ǿͻ��˷���ģʽ��һ���ܺõ����ӡ�

Spring Boot�У����������ɵ�ʹ��spring-cloud-starter-eureka-server������@EnableEurekaServerע��ͼ򵥵���������������Eureka ע�ᡣ

�ͻ���֧����bootstrap.yml��ʹ��@EnableDiscoveryClientע�⣬��Ӧ����ʶ��

``` yml
spring:
  application:
    name: notification-service
```

���ڣ���Ӧ�ó�������ʱ������ע�ᵽEureka���������ṩԪ���ݣ��������Ͷ˿ڣ�����ָʾ��URL����ҳ�ȡ�Eureka������һ�������ÿ��ʵ������������Ϣ������ڿ����õ�ʱ������������ϣ���ʵ������ע�����ɾ����

���⣬Eureka�ṩ��һ���򵥵Ľ��棬�����Ը������еķ���Ϳ���ʵ������

`http://localhost:8761`

### ���ؾ���������·����Http�ͻ���

Netflix OSS�ṩ��һϵ��ǿ��Ĺ��߼��� 

#### Ribbon
Ribbon��һ�����Զ�HTTP��TCP�ͻ��˵���Ϊ���п��ƿͻ��˸��ؾ��������봫ͳ�ĸ��ؾ�������ȣ�Ribbon�����ÿ�����ϵ��ö�����������������ֱ�ӷ�������ķ���

����Spring Cloud�ͷ����ֱ����ɣ���˿ɿ��伴�á� [Eureka Client](https://github.com/sqshq/PiggyMetrics#service-discovery)�ṩ�˿��÷������Ķ�̬�б��Ա�Ribbon����������֮�����ƽ�⡣


#### Hystrix
Hystrix�Ƕ�·��ģʽ��[Circuit Breaker pattern](http://martinfowler.com/bliki/CircuitBreaker.html)����ʵ�֣����ṩ�˶�ͨ��������ʵ������Ե��ӳٺ͹��ϵĿ��ơ���Ҫʵ��˼·���ھ��д���΢����ķֲ�ʽ������ֹͣ�������ϡ����ݴ�ϵͳ�������������棬���������󾡿��ܵĿ��ٷ��ֲ��һָ���

���˶�·�����ƣ�ʹ��Hystrix�����������һ���󱸷�������������ʧ�ܵ�����µ��ø÷����Ի�ȡĬ��ֵ��

���⣬Hystrix����ÿ�������ִ�н�����ӳٵ�ָ�꣬���ǿ�������������ϵͳ��Ϊ��[monitor system behavior](https://github.com/sqshq/PiggyMetrics#monitor-dashboard)����


#### Feign

Feign��һ����Ribbon��Hystrix�޷켯�ɵ�����ʽHttp�ͻ��ˡ�ʵ���ϣ�ʹ��һ��`spring-cloud-starter-feign`������`@EnableFeignClients`ע�⣬��ӵ��һ�������ĸ��ؾ���������·����Http�ͻ����Լ�����ļ�����Ĭ�����á�
�������ʻ������ʾ����


����Ҫ��ֻ��һ���ӿڣ�?

``` java
@FeignClient(name = "statistics-service")
public interface StatisticsServiceClient {

	@RequestMapping(method = RequestMethod.PUT, value = "/statistics/{accountName}", consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
	void updateStatistics(@PathVariable("accountName") String accountName, Account account);

}
```

- ����Ҫ��ֻ��һ���ӿ�
-?�������Spring MVC��������Feign����֮�乲��`@RequestMapping` 
- ͨ��Eureka�Զ����֣������ʾ��ָ��ֻ��Ҫ����id  - ͳ�Ʒ��񣬣���Ȼ�������Է����κ���Դ���ض���URL��

### �����Ǳ���?

�������Ŀ�����У�Hystrix��ÿ��΢����ͨ��Spring Cloud Bus��ʹ��AMQP������ָ�����͵�Turbine������Ŀֻ����? [Turbine](https://github.com/Netflix/Turbine)?�� [Hystrix Dashboard](https://github.com/Netflix/Hystrix/tree/master/hystrix-dashboard)���ɵ�Spring BootӦ�á�


 [���濴���������](https://github.com/sqshq/PiggyMetrics#how-to-run-all-the-things).

�����ǿ������ǵ�ϵͳ�ڸ����µ���Ϊ���ʻ��������ͳ�Ʒ���ʱ��ͨ����ͬ��ģ���ӳٽ�����Ӧ����Ӧ��ʱ��ֵ����Ϊ1�롣

<img width="880" src="https://cloud.githubusercontent.com/assets/6069066/14194375/d9a2dd80-f7be-11e5-8bcc-9a2fce753cfe.png">

<img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127349/21e90026-f628-11e5-83f1-60108cb33490.gif">	| <img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127348/21e6ed40-f628-11e5-9fa4-ed527bf35129.gif"> | <img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127346/21b9aaa6-f628-11e5-9bba-aaccab60fd69.gif"> | <img width="212" src="https://cloud.githubusercontent.com/assets/6069066/14127350/21eafe1c-f628-11e5-8ccd-a6b6873c046a.gif">
--- |--- |--- |--- |
| `0 ms �ӳ�` | `500 ms �ӳ�` | `800 ms �ӳ�` | `1100 ms �ӳ�`
| ϵͳ�������á�������ԼΪ22����/�롣ͳ�Ʒ����еĻ�߳������١���λ����ʱ��ԼΪ50 ms�� | ��̵߳����������ӡ����ǿ��Կ�����ɫ�̳߳ؾܾ������������Լ30-40���Ĵ��󣬵���ѯ��Ȼ�رա� | �뿪״̬����������ı��ʴ���50������·����������˯�ߴ��ڵ�ʱ�����һ����������ͨ���� | 100��������ʧ�ܡ���ѯ�������ô򿪡���˯��ʱ������Բ����ٴαպ���ѯ����Ϊ��������̫����

### ��־����

�������ڷֲ�ʽ������ʶ������ʱ������ʽ��־��¼���ܷǳ����á�ʹ��Elasticsearch��Logstash��Kibana stack�����������ɵ������ͷ���������־����Դ�����ʺ��������ݡ����Դ��ҵ�������Ŀ[ my other project](http://github.com/sqshq/ELK-docker)���˽�Docker���á�



## ��ȫ��

�߼���ȫ���ó����˴˸�����֤��Ŀ�ķ�Χ���ڸ���ʵ��ģ��ϵͳ�У�����ʹ��https��JCE��Կ�����΢������������÷������������ݣ��й���ϸ��Ϣ�������[�ĵ�](http://cloud.spring.io/spring-cloud-config/spring-cloud-config.html#_security)��

## �����ܹ��Զ���

��Ȳ��𵥸���Ӧ�ó��򣬲���΢�������໥������Ҫ���ӵö࣬ӵ����ȫ�Զ����Ļ����ܹ��Ե÷ǳ���Ҫ�����ǿ���ͨ����������������������洦��

- ��ʱ��������汾������
- �κι������������Է���
- һ�ι���- ������Ҫ���� 

�����Ŀ��ʵ����һ���򵥵ĳ���������������

<img width="880" src="https://cloud.githubusercontent.com/assets/6069066/14159789/0dd7a7ce-f6e9-11e5-9fbb-a7fe0f4431e3.png">

�ڴ�������( [configuration](https://github.com/sqshq/PiggyMetrics/blob/master/.travis.yml))��Travis CIΪÿ���ɹ���git push������ǵľ�����ˣ�����Docker Hub�;ɾ����ϵ�ÿ��΢����ʼ�������µľ������Ƕ���git commit hash���б�ǡ������Ҫ�����ٲ����ع��κ�һ�����񽫻��ü򵥡�

## ����������л���?

��ס����Ҫ����8��Spring BootӦ�ó���4��MongoDBʵ����RabbitMq��ȷ�����Ļ�������4 Gb RAM���á�������ʼ��������Ҫ�ķ������أ�ע�ᣬ���ã���֤������ʻ�����

#### ���㿪ʼ֮ǰ
- ��װ Docker and Docker Compose.
- ������������: `CONFIG_SERVICE_PASSWORD`, `NOTIFICATION_SERVICE_PASSWORD`, `STATISTICS_SERVICE_PASSWORD`, `ACCOUNT_SERVICE_PASSWORD`, `MONGODB_PASSWORD`

#### ����ģʽ
������ģʽ�£��������µľ��񽫴�Docker Hub����ȡ��ֻ�踴�� `docker-compose.yml`����ִ�� `docker-compose up -d`��?

#### ����ģʽ
��������Լ��������������ڴ�������һЩ�仯����������ʹ��maven��¡���еĿ��artifacts?��.Ȼ�󣬼̳�`docker-compose.yml`���� `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d` `docker-compose.dev.yml` �������ڱ��ع���ӳ�񣬲��������������˿��Է��㿪����

#### ��Ҫ�ڵ�
- http://DOCKER-HOST:80 - Gateway
- http://DOCKER-HOST:8761 - Eureka Dashboard
- http://DOCKER-HOST:9000/hystrix - Hystrix Dashboard
- http://DOCKER-HOST:8989 - Turbine stream (source for the Hystrix Dashboard)
- http://DOCKER-HOST:15672 - RabbitMq ���� (default login/password: guest/guest)

#### ˵��
����Spring BootӦ�ó�����Ҫ����[Config Server](https://github.com/sqshq/PiggyMetrics#config-service)������������Ϊʹ����`fail-fast` Spring Boot���Ժ�`restart: always`?docker-compose?ѡ����ǿ���ͬʱ��������������
����ζ����Config Server����������֮ǰ��������������������������������

���⣬�����ֻ�����Ҫ������Ӧ�ó���������һ��ʱ�������Ч����ʵ����Eureka�������Ϳͻ��˶����䱾�ػ����о�����ͬ��Ԫ����ǰ�������ֻ��ƽ������á���ˣ���������Ҫ3��������Ĭ����������Ϊ30�롣

## ��ӭ����

PiggyMetrics�ǿ�Դ�ģ��ǳ������͸�л���İ�������ʱ������ϵ�κ����⡣
