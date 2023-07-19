TAG="starina/squid-sarg-cron:latest"
docker image build -t $TAG . && docker push $TAG
