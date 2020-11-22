docker-build:
	docker-compose build

docker-up:
	docker-compose up

docker-down:
	docker-compose down

import-db:
    docker exec -i info-guru-db mysql -u wordpress --password=password wordpress < data.sql
    #docker exec -it info-guru-db bin/bash && mysql -u wordpress --password=password wordpress < /docker-entrypoint-initdb.d/data.sql


#docker exec -i info-guru-db mysql -u wordpress --password=password wordpress < data.sql

# Restore
# cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE
#export-db:
#    cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE