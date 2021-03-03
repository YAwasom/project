# ============================================================================================
# TODO:
# Create a script that will take the following arguments:
# image-name from a list of valid image names (can take the index only)
# tag-name (default to none)
# pull the image from the blitline inventory and update the non-prod ecr repository with the image
# ============================================================================================

# #Imagemagic 7 + gs
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-im7-gs

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-im7-gs \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-im7-gs:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-im7-gs:latest

# #Worker
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)

echo $(aws ecr get-login-password --region us-east-1)|docker login --password-stdin --username AWS 613648124410.dkr.ecr.us-east-1.amazonaws.com

eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-worker

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-worker \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-worker:latest

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-worker \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-worker:beta

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}

echo $(aws ecr get-login-password --region us-west-2)|docker login --password-stdin --username AWS 348180535083.dkr.ecr.us-west-2.amazonaws.com

docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-worker:latest
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-worker:beta

# #Sandbox

BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-sandbox

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-sandbox \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-sandbox:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 147180035125 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-sandbox:latest

# #Web
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-web

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-web \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-web:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-web:latest

#longpolling-cache
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-longpolling-cache

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-longpolling-cache \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-longpolling-cache:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-longpolling-cache:latest

# #Office Headless
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-office-headless

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-office-headless \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-office-headless:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-office-headless:latest

# #sandbox-controller
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-sandbox-controller

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-sandbox-controller \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-sandbox-controller:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-sandbox-controller:latest

# #allq-server
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-allq-server

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-allq-server \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-allq-server:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-allq-server:latest

#allq-client
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-allq-client

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-allq-client \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-allq-client:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-allq-client:latest

# #background
BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-background

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-background \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-background:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-background:latest

# #batik

BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-batik

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-batik \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-batik:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-batik:latest

# #tikaserver

BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-tikaserver

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-tikaserver \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-tikaserver:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-tikaserver:latest

# cedis

BLITLINECMD=$(aws ecr get-login --registry-ids 613648124410 --region us-east-1 --no-include-email)
eval ${BLITLINECMD}
docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-cedis

docker tag \
613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-cedis \
348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-cedis:latest

CONTENTNOWCMD=$(aws ecr get-login --registry-ids 348180535083 --region us-west-2 --no-include-email)
eval ${CONTENTNOWCMD}
docker push 348180535083.dkr.ecr.us-west-2.amazonaws.com/blitline/blitline-cedis:latest



# SANDBOX
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-office-headless
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-sandbox-controller
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-sandbox
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-web
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-allq-server
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-background
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-batik
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-tikaserver
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-web
# docker pull 613648124410.dkr.ecr.us-east-1.amazonaws.com/standalone/blitline-worker


#------


# {
# 	"ruFS+dY,ms-stg.blitline.warnerbros.com:7788": {
# 		"default": {
# 			"ready": "0", // hasnt been picked up yet  [alert if > 3 or more]
# 			"delayed": "0", // supposed to be processed later [going to be processed later]
# 			"reserved": "0", // being worked on now [ how many jobs are in flight right now]
# 			"buried": "0", // failed 3 times -> its a DLQ
# 			"parents": "7"  // some jobs are parents of other jobs. these jobs are necessary for other jobs to be done
# 		},
# 		"long_running": {
# 			"ready": "0",
# 			"delayed": "0",
# 			"reserved": "0",
# 			"buried": "0",
# 			"parents": "0"
# 		},
# 		"docker": {
# 			"ready": "7",
# 			"delayed": "0",
# 			"reserved": "0",
# 			"buried": "0",
# 			"parents": "0"
# 		},
# 		"global": {
# 			"action_count": "253325"
# 		}
# 	}
# }
