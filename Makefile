build:
	docker build -t rubiconred/oracle-code .

up:	destroy build
	docker port `docker run -P -d rubiconred/oracle-code` 4000
	docker ps -l -q > cid

destroy:
	[ -f cid ] && docker rm -f `cat cid` && rm cid || true
