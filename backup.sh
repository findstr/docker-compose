#!/bin/bash
PREFIX="docker_"
SQL="wordpress.sql"
WP="home/wwwroot/blog.gotocoding.com/wp-content"
REDIS="data/"

function backup()
{
	echo "Backup start ..."
	sudo docker exec ${PREFIX}mysql_1 /usr/bin/mysqldump -u root --password=wp wordpress> ${SQL}
	sudo docker run --rm --volumes-from ${PREFIX}php_1 -v $(pwd):/backup busybox tar -C/ -czvf /backup/wordpress.tar.gz  ${WP}
	sudo docker run --rm --volumes-from ${PREFIX}redis_1 -v $(pwd):/backup busybox tar -C/ -czvf /backup/wordpress.tar.gz ${REDIS}
	echo "Backup finish."
}

function restore()
{
	echo "Restore start ..."
	sudo docker exec ${PREFIX}mysql_1 /usr/bin/mysql -u root --password=wp wordpress < ${SQL}
	sudo docker run --rm --volumes-from ${PREFIX}php_1 -v $(pwd):/backup busybox tar -C/ -czvf /backup/wordpress.tar.gz  ${WP}
	sudo docker run --rm --volumes-from ${PREFIX}redis_1 -v $(pwd):/backup busybox tar -C/ -czvf /backup/wordpress.tar.gz ${REDIS}
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

