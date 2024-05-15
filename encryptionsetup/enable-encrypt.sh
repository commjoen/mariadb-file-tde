#bin/bash

genereate_keys() {
    mkdir -p /etc/mysql/encryption
    echo "1;"$(openssl rand -hex 32) > /etc/mysql/encryption/keyfile
    cat /etc/mysql/encryption/keyfile
    openssl rand -hex 128 > /etc/mysql/encryption/keyfile.key
    openssl enc -aes-256-cbc -md sha1 -pass file:/etc/mysql/encryption/keyfile.key -in /etc/mysql/encryption/keyfile -out /etc/mysql/encryption/keyfile.enc
    rm -f /etc/mysql/encryption/keyfile
    ls -lrt /etc/mysql/encryption/
    chown -R mysql:mysql /etc/mysql
    chmod -R 500 /etc/mysql
    ls -lRt /etc/mysql
}

enable_encryption(){
tee -a /etc/mysql/my.cnf <<EOF

[mariadb]
plugin_load_add = file_key_management
file_key_management_filename = /etc/mysql/encryption/keyfile.enc
file_key_management_filekey = FILE:/etc/mysql/encryption/keyfile.key
file_key_management_encryption_algorithm = AES_CTR

innodb_encrypt_tables = FORCE
innodb_encrypt_log = ON
innodb_encrypt_temporary_tables = ON

encrypt_tmp_disk_tables = ON
encrypt_tmp_files = ON
encrypt_binlog = ON
aria_encrypt_tables = ON

innodb_encryption_threads = 4
innodb_encryption_rotation_iops = 2000
EOF
}

if test -f /etc/mysql/encryption/keyfile.enc; then
    echo "Encryption files are set, skipping generation"
else
   genereate_keys
fi

if grep -R "file_key_management_filename" /etc/mysql/my.cnf
then
   echo "config is set, skipping"
else
   echo "config is not yet set, overriding"
   enable_encryption
fi



