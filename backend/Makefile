app-init: app-migrate app-seed app-run
app-init-db: app-migrate app-seed


app-migrate:
	python server.py --database --migrate

app-downgrade-all:
	python server.py --database --downgrade-all

app-seed:
	python server.py --seed

app-run:
	echo "Running in production mode."
	./dist/server/server --start

