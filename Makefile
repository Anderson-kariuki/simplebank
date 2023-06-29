postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15

createdb: 
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

accessdb:
	docker exec -it postgres15 psql -U root simple_bank	

dropdb: 
	docker exec -it postgres15 dropdb simple_bank

stoppostgres:
	docker stop postgres15

removepostgres:
	docker rm postgres15

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down
	
sqlc:
	docker run --rm -v "%cd%:/src" -w /src kjconroy/sqlc generate	
	
test:
	go test -v -cover ./...

.PHONY: postgres createdb accessdb dropdb stoppostgres removepostgres migrateup migratedown sqlc test