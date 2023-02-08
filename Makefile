image:
	docker build --rm -t cwesdorp/smart_meter_telegraf:latest

run:
	docker run -d --device=/dev/ttyUSB0 \
	  --name=smart_meter \
	  -v "${PWD}/telegraf.d:/etc/telegraf.d:ro" \
	  cwesdorp/smart_meter_telegraf:latest

run-attached:
	docker run -t -a STDOUT \
	  --device=/dev/ttyUSB0 \
	  --name=smart_meter \
	  -v "${PWD}/telegraf.d:/etc/telegraf.d:ro" \
	  cwesdorp/smart_meter_telegraf:latest
