.PHONY: gogo all app bench slow-log kataribe
all: gogo

app:
	make -C webapp/go build

gogo:
	sudo systemctl stop h2o.service
	sudo systemctl stop torb.go.service
	sudo systemctl stop mariadb
	sudo truncate --size 0 /var/log/h2o/access.log
	sudo truncate --size 0 /var/log/h2o/error.log
	sudo truncate --size 0 /var/lib/mysql/mysql-slow.log
	sudo truncate --size 0 /var/log/mariadb/mariadb.log
	$(MAKE) app
	sudo systemctl start mariadb
	sudo systemctl start torb.go.service
	sudo systemctl start h2o.service
	sleep 2
	# make bench

bench:
	# ssh -i ~/.ssh/id_rsa centos@54.168.238.28 sudo su - isucon && cd /home/isucon/
	# ssh -i ~/.ssh/id_rsa centos@54.168.238.28 sudo jq . < result.json

slow-log:
	sudo cp /var/lib/mysql/mysql-slow.log /tmp/mysql-slow.log
	sudo chmod 777 /tmp/mysql-slow.log

kataribe:
	sudo cp /var/log/h2o/access.log /tmp/last-access.log && sudo chmod 666 /tmp/last-access.log
	cat /tmp/last-access.log | ./kataribe -conf kataribe.toml > /tmp/kataribe.log
	cat /tmp/kataribe.log

