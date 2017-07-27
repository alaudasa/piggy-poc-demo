#!/bin/bash
cd $(dirname $0)
NAMESPACE=${NAMESPACE:-admin}
APP=(
	auth-service
	notification-service
	monitoring
	statistics-service
	account-service
	gateway
	registry
	config
	)

PREFIX="piggymetrics-"
TMPDIR=$(mktemp -d)


#get endpoint_id
endpoint_id=$(
curl -s -X GET						\
	 -H "Authorization: Token $TOKEN" 		\
	 -H "Cache-Control: no-cache" 			\
	 -H "Content-Type: text/html;charset:utf-8"	\
	"$API_URL/private-build-endpoints/admin" 	|\
	./jq ".[0].endpoint_id" 			|\
	sed 's/"//g'
	)

for srv in ${APP[*]}
do
	FULLNAME="${PREFIX}${srv}"
	cat > $TMPDIR/$FULLNAME.json <<EOF
	{
    "name": "$FULLNAME",
    "image_cache_enabled": true,
    "auto_build_enabled": true,
    "code_repo": {
        "code_repo_client": "SIMPLE_GIT",
        "code_repo_path": "http://$GITLAB_ADDR/root/piggymetrics.git",
        "code_repo_type": "BRANCH",
        "code_repo_type_value": "master",
        "build_context_path": "/$srv",
        "dockerfile_location": "/$srv"
    },
    "auto_tag_type": "COMMIT",
    "customize_tag": "latest",
    "image_repo": {
        "name": "$FULLNAME",
        "registry": {
            "name": "$IMG_REPO"
        },
        "project": {
            "name": "alauda-poc"
        }
    },
    "endpoint_id": "$endpoint_id",
    "ci_enabled": true,
    "ci_config_file_location": "/$srv",
    "namespace": "admin"
}
EOF

curl -s -X POST 			\
-H "Authorization: Token $TOKEN" 	\
-H "Cache-Control: no-cache" 		\
-H "Content-Type: application/json"	\
-d @$TMPDIR/$FULLNAME.json		\
"$API_URL/private-build-configs/admin" |\
grep -qiv errors || {
	 	echo "Create $FULLNAME failed."
}
done

#echo "------ Template -----"
cat > $TMPDIR/app_template.tpl <<EOF
rabbitmq:
  image: $REGISTRY_ADDR/alauda-poc/rabbitmq:3-management
  ports:
    - '15672'
    - '5672'
  net: flannel
data-mongodb:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-mongodb
  environment:
    INIT_DUMP: account-service-dump.js
    MONGODB_PASSWORD: admin 
  ports:
    - '27017'
  net: flannel
 
config:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-config
  environment:
    CONFIG_SERVICE_PASSWORD: admin
  links:
    - 'rabbitmq:rabbitmq'
    - 'data-mongodb:data-mongodb'
  ports:
    - '8888'
  net: flannel
 
registry:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-registry
  environment:
    CONFIG_SERVICE_PASSWORD: admin
  links:
    - 'config:config'
  alauda_lb: ALB
  ports:
    - '$ALB_HOST:8761:8761/http'
  net: flannel
 
gateway:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-gateway
  environment:
    CONFIG_SERVICE_PASSWORD: admin 
  links:
    - 'config:config'
  alauda_lb: ALB
  ports:
    - '$ALB_HOST:80:4000/http'
  net: flannel
 
auth-service:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-auth-service
  environment:
      CONFIG_SERVICE_PASSWORD: admin
      NOTIFICATION_SERVICE_PASSWORD: admin
      STATISTICS_SERVICE_PASSWORD: admin
      ACCOUNT_SERVICE_PASSWORD: admin
      MONGODB_PASSWORD: admin
  links:
    - 'config:config'
  ports:
    - '5000'
  net: flannel
 
account-service:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-account-service
  environment:
    CONFIG_SERVICE_PASSWORD: admin
    ACCOUNT_SERVICE_PASSWORD: admin
    MONGODB_PASSWORD: admin
  links:
    - 'config:config'
  ports:
    - '6000'
  net: flannel
 
statistics-service:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-statistics-service
  environment:
    CONFIG_SERVICE_PASSWORD: admin
    MONGODB_PASSWORD: admin
    STATISTICS_SERVICE_PASSWORD: admin
  links:
    - 'config:config'
  ports:
    - '7000'
  net: flannel
 
notification-service:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-notification-service
  environment:
    CONFIG_SERVICE_PASSWORD: admin
    MONGODB_PASSWORD: admin
    NOTIFICATION_SERVICE_PASSWORD: admin
  links:
    - 'config:config'
  ports:
    - '8000'
  net: flannel
 
monitoring:
  image: $REGISTRY_ADDR/alauda-poc/piggymetrics-monitoring
  environment:
    CONFIG_SERVICE_PASSWORD: admin
  links:
    - 'config:config'
  alauda_lb: ALB
  ports:
    - '$ALB_HOST:9000:8080/http'
    - '8989'
  net: flannel
EOF

#Create app_template
curl -s -X POST                                         \
         -H "Authorization: Token $TOKEN"               \
         -H "Cache-Control: no-cache"                   \
         -F "template=@$TMPDIR/app_template.tpl"	\
         -F "name=piggymetrics"				\
         -F "description=Piggymetrics"			\
         -H "Content-Type: multipart/form-data;charset=UTF-8" \
         "$API_URL/application-templates/admin/"

echo "---- done. ----"
