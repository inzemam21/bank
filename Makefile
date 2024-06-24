.PHONY: postgres createdb dropdb migrateup migratedown test server mock

postgres:
	docker run --name bank -p 5433:5432 -e POSTGRES_PASSWORD=root -d postgres:12.19-alpine

createdb:
	docker exec -it bank createdb --username=postgres --owner=postgres simple_bank

dropdb: 
	docker exec -it bank dropdb --username=postgres --owner=postgres simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:root@localhost:5433/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://postgres:root@localhost:5433/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/inzemam21/simplebank/db/sqlc Store

    
