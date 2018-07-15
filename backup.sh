#!/bin/bash
PREFIX="compose_"
SQL="wordpress.sql"
WP="home/wwwroot/blog.gotocoding.com/wp-content"
REDIS="data/"

function backup()
{
	echo "Backup start ..."
	sudo docker exec ${PREFIX}mysql_1 /usr/bin/mysqldump -u root --password=wp --databases wordpress> ${SQL}
	sudo docker run --rm --volumes-from ${PREFIX}php_1 -v $(pwd):/backup busybox tar -C/ -czvf /backup/wordpress.tar.gz  ${WP}
	sudo docker run --rm --volumes-from ${PREFIX}redis_1 -v $(pwd):/backup busybox tar -C/ -czvf /backup/redis.tar.gz ${REDIS}
	echo "Backup finish."
}

function restore()
{
	echo "Restore start ..."
	sudo docker exec -i ${PREFIX}mysql_1 /usr/bin/mysql -u root --password=wp < ./${SQL}
	sudo docker run --rm --volumes-from ${PREFIX}php_1 -v $(pwd):/backup busybox tar -C/ -zxvf /backup/wordpress.tar.gz
	sudo docker run --rm --volumes-from ${PREFIX}redis_1 -v $(pwd):/backup busybox tar -C/ -zxvf /backup/redis.tar.gz
	echo "Restore finish."
}

case $1 in
	backup)
		backup;;
	restore)
		restore
		;;
	*)
		echo "xxxx"
		;;
esac

