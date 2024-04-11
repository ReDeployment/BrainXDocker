
run-dev:
	echo "Running in dev mode."
	# app.main: 使用 .来指定路径文件main
	# main: the file main.py (the Python "module").
	# app: the object created inside of main.py with the line app = FastAPI().
	# --reload: make the server restart after code changes. Only use for development.
	poetry run uvicorn app.main:app --reload

run:
	echo "Running in production mode."
	poetry run uvicorn app.main:app