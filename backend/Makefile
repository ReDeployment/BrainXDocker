app-init: app-migrate app-seed app-run
app-init-db: app-migrate app-seed


app-migrate:
	./dist/server/server --database --migrate

app-downgrade-all:
	./dist/server/server --database --downgrade-all

app-seed:
	./dist/server/server --seed

app-run:
	echo "Running in production mode."
	./dist/server/server --start

