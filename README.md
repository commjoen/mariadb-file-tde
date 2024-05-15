# MariaDB File TDE

This is a quick PoC to use docker-compose in order to setup file based TDE for mariaDB based on https://mariadb.com/resources/blog/mariadb-encryption-tde-using-mariadbs-file-key-management-encryption-plugin/

## how to use it

1. check docker-compose.yml: start it as:
```yaml
volumes:
  data:
services:
  db:
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    volumes:
      - data:/var/lib/mysql
      - ./dev/mariadb:/docker-entrypoint-initdb.d
      - ./encryptionsetup:/etc/initencrypt
      - ${PWD}/encryptionsetup/my.cnf:/etc/mysql/my.cnf
      - ./encryptionkeys:/etc/mysql/encryption
    ports:
      - "3306:3306"
```
2. run automate.sh and exec into the mariadb container, where you execute `/etc/initencrypt/enable-encrypt.sh`.
3. exit the container, now you can enable the data mount and continue