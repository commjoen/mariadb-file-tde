#bin/bash

genereate_keys() {
    
    echo "1;"$(openssl rand -hex 32) > ../encryptionkeys/keyfile
    cat ../encryptionkeys/keyfile
    openssl rand -hex 128 > ../encryptionkeys/keyfile.key
    openssl enc -aes-256-cbc -md sha1 -pass file:../encryptionkeys/keyfile.key -in ../encryptionkeys/keyfile -out ../encryptionkeys/keyfile.enc
    rm -f ../encryptionkeys/keyfile
    # ls -lrt ../encryptionkeys/keyfile
    # chown -R mysql:mysql /etc/mysql
    # chmod -R 500 /etc/mysql
    # ls -lRt /etc/mysql
}

if test -f ../encryptionkeys/keyfile.enc; then
    echo "Encryption files are set, skipping generation"
else
   genereate_keys
fi

