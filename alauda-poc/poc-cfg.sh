export   GITLAB_HOST="10.0.0.8"         #Local_IP
export   GLOBAL_HOST="10.0.0.5"         #Global
export REGISTRY_HOST="10.0.0.6"         #Master
export         TOKEN='d1bbc0d7d980bcd086d608966361988e32a260fa'
export       API_URL='http://rubick.alauda.internal:81/v1' 
export      IMG_REPO='reg-kk'           #reg_repository name 镜像仓库的repository


export      ALB_HOST=${REGISTRY_HOST}
       REGISTRY_USER=${REGISTRY_USER:-admin}
       REGISTRY_PASS=${REGISTRY_PASS:-admin}
       REGISTRY_PORT=${REGISTRY_PORT:-5000}
         GITLAB_PORT=${GITLAB_PORT:-9999}
              DOMAIN="rubick.alauda.internal"
export REGISTRY_ADDR=${REGISTRY_HOST}:${REGISTRY_PORT}
export   GITLAB_ADDR=${GITLAB_HOST}:${GITLAB_PORT}
