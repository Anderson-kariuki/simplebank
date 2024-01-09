postgres:
	docker run --name postgres15 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

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

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	docker run --rm -v "%cd%:/src" -w /src kjconroy/sqlc generate	
	
test:
	go test -v -cover ./...

server:
	go run main.go

build:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/Anderson-kariuki/simplebank/db/sqlc Store

.PHONY: postgres createdb accessdb dropdb stoppostgres removepostgres migrateup migrateup1 migratedown migratedown1 sqlc test server build mock