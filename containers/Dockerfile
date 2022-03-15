FROM mariadb:10.5

COPY dump.sql /var/lib/mysql/.
#RUN mysqld
RUN  /usr/bin/mysql --user profi  --password=bikeminerdb bikeminer < /var/lib/mysql/dump.sql

EXPOSE 3306

CMD ["mysqld"]
