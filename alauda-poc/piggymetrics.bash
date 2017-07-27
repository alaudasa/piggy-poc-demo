#!/bin/bash
cd $(dirname $0)
SHPATH=${PWD}

. poc-cfg.sh

#   ->
echo 	"$GLOBAL_HOST $DOMAIN" >> /etc/hosts
#Create org_project -> "alauda-poc"
curl -s -X POST 					\
	 -H "Authorization: Token $TOKEN" 		\
	 -H "Cache-Control: no-cache" 			\
	 -H "Content-Type: application/json" 		\
	 -d '{"name": "alauda-poc"}'			\
	 "$API_URL/registries/admin/$IMG_REPO/projects" |\
	 grep -qiv errors || {
	 	echo "Failed to create the project -> 'alauda-poc'"
	 	exit 1
	 }

#push
docker login \
-u ${REGISTRY_USER} \
-p ${REGISTRY_PASS} \
${REGISTRY_ADDR}

#load
for f in java_8-jre\
	 maven-ci_latest\
	 piggymetrics-mongodb_latest\
	 rabbitmq_3-management
do
docker load -i base_img/${f}.tar
docker tag ${f/_/:} ${REGISTRY_ADDR}/alauda-poc/${f/_/:}
docker push $_
done

#replace alaudaci.yml & Dockerfile

cd ${SHPATH}/srcpush/piggymetrics
find ./ ! -path ./mongodb/Dockerfile 	\
-name "Dockerfile"  					\
-exec sed -i '/^FROM/ s/^.*$/FROM '"$REGISTRY_ADDR"'\/alauda-poc\/java:8-jre/' {} \;

find ./ -name "alaudaci.yml"	\
-exec sed -i '/^\s\+image.*$/ s/\(\s\+image: \).*/\1'"$REGISTRY_ADDR\/alauda-poc\/maven-ci"'/g' {} \;



#Add_cfg
bash ${SHPATH}/script/create_build_cfg.bash
#
cd ${SHPATH}
docker run --net=host --rm  -v `pwd`/srcpush/:/srcpush git_push /srcpush/push.bash pm

