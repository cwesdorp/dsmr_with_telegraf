image:
	docker build --rm -t cwp/smt:1 .

run:
	docker run --rm -t --device=/dev/ttyUSB0 cwp/smt:1 
