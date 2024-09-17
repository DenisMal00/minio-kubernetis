#!/bin/bash

# Configuration
MINIO_ALIAS="myminio"
MINIO_URL="http://localhost:80"  # Update this based on your setup
ACCESS_KEY="minio"
SECRET_KEY="minio123"
ADMIN_POLICY="consoleAdmin"  # Predefined admin policy

# Function to create admin user
create_admin_user() {
    local username=$1
    local password=$(openssl rand -base64 12)

    # Set MinIO alias for the mc command
    mc alias set $MINIO_ALIAS $MINIO_URL $ACCESS_KEY $SECRET_KEY --insecure

    # Create the admin user and attach the admin policy
    mc admin user add $MINIO_ALIAS $username $password
    mc admin policy attach $MINIO_ALIAS $ADMIN_POLICY --user $username

    # Display created user details
    echo "Admin user $username created successfully."
    echo "Username: $username"
    echo "Password: $password"
}

# Check if a username is provided as an argument
if [ -z "$1" ]; then
    echo "Error: No username provided."
    echo "Usage: $0 <username>"
    exit 1
fi

# Create the admin user
create_admin_user $1
