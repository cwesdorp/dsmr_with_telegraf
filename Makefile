image:
	docker build --rm -t cwp/smt:1 .

image-telegraf:
	docker build --rm -t cwp/smt-telegraf:2 -f Dockerfile-telegraf .

run:
	docker run --rm --device=/dev/ttyUSB0 -v "${PWD}/telegraf-influxdb_v2.conf:/etc/telegraf/telegraf.conf" --name=smart_meter -d cwp/smt-telegraf:2 

run-test:
	docker run --rm -t --device=/dev/ttyUSB0 -v "${PWD}/telegraf.conf:/etc/telegraf/telegraf.conf" --name=smart_meter -a STDOUT cwp/smt-telegraf:2 
