
build:
	docker build -t ppiccolo/pgadmin4 .

run:
	docker run --rm -it -p 5999:5999 -v `pwd`/.pgadmin4:/data ppiccolo/pgadmin4
