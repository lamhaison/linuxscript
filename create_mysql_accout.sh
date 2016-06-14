USERNAME=lamhaison
PASSWORD=lamhaison
DATABASE_NAME=lamhaison
ACCESS_IP=localhost
mysql -u root -e 'create database $DATABASE_NAME'
mysql -u root -e "CREATE USER '$USERNAME'@'$ACCESS_IP' IDENTIFIED BY '$PASSWORD'"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$USERNAME'@'$ACCESS_IP' WITH GRANT OPTION"
mysql -u root -e "SHOW GRANTS FOR '$USERNAME'@'$ACCESS_IP'"

