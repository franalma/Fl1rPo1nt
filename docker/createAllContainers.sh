cd apidb
docker-compose create
cd .. 
cd authdb
docker-compose create
cd .. 
cd chatdb
docker-compose create
cd .. 
cd multimediadb create
docker-compose create
cd .. 



# docker run -d --name floiint_auth -p 20000:27017 --user 999:999 -v /Volumes/Public/Floiint/databases/auth:/data/db mongo
# docker run -d --name floiint_api -p 20100:27017 --user 999:999 -v /Volumes/Public/Floiint/databases/api:/data/db mongo
# docker run -d --name floiint_chat -p 20200:27017 --user 999:999 -v /Volumes/Public/Floiint/databases/chat:/data/db mongo
# docker run -d --name floiint_mult -p 20300:27017 --user 999:999 -v /Volumes/Public/Floiint/databases/mult:/data/db mongo
