FROM mariadb:latest
ADD sql_initdb.sql /docker-entrypoint-initdb.d/ddl.sql
