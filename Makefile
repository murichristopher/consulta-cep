.PHONY: db setup reset

db:
	@if [ "`docker ps | grep my_postgres`" ]; then \
		echo "PostgreSQL container is already running."; \
	elif [ "`docker ps -a | grep my_postgres`" ]; then \
		echo "Starting existing PostgreSQL container."; \
		docker start my_postgres; \
	else \
		echo "Running a new PostgreSQL container."; \
		docker run --name my_postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres:16.2-alpine; \
	fi

setup:
	rails db:drop db:create db:migrate db:seed
