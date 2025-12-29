docker build --platform linux/amd64 -t my-app:v1.0.0 .

docker build --platform linux/amd64 -t my-app:v2.0.0 .

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $accountID.dkr.ecr.us-east-1.amazonaws.com
docker tag my-app:v1.0.0 $accountID.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.0.0
docker push $accountID.dkr.ecr.us-east-1.amazonaws.com/my-app:v1.0.0