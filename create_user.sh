#!/bin/bash

MINIO_ALIAS="myminio"
MINIO_URL="http://localhost:80"
ACCESS_KEY="minio"
SECRET_KEY="minio123"

create_user() {
    local username=$1
    local password=$(openssl rand -base64 12)

    mc alias set $MINIO_ALIAS $MINIO_URL $ACCESS_KEY $SECRET_KEY --insecure

    local bucket_name="${username}-bucket"
    mc mb ${MINIO_ALIAS}/${bucket_name} --insecure

    local policy_name="${username}-policy"
    local policy_file="${policy_name}.json"

    echo '{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::'${bucket_name}'",
            "arn:aws:s3:::'${bucket_name}'/*"
          ]
        }
      ]
    }' > $policy_file

    mc admin policy create $MINIO_ALIAS $policy_name $policy_file

    mc admin user add $MINIO_ALIAS $username $password
    mc admin policy attach $MINIO_ALIAS $policy_name --user $username

    rm $policy_file

    echo "Utente $username creato con successo."
    echo "Nome utente: $username"
    echo "Password: $password"
}

if [ -z "$1" ]; then
    echo "Errore: nessun nome utente fornito."
    echo "Uso: $0 <nome_utente>"
    exit 1
fi

create_user $1

