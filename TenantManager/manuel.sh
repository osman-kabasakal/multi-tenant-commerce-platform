#!/bin/bash

# Env dosyasını yükle
#if [ -f manuel.env ]; then
#    source manuel.env
#else
#    echo "Error: .env file not found"
#    exit 1
#fi

## Env dosyasını yükle
#if [ -f manuel.env ]; then
#    # Her bir değişkeni export et
#    while IFS= read -r line || [ -n "$line" ]; do
#        if [[ $line =~ ^[^#] ]]; then
#          echo 
#            export "${line?}"
#        fi
#    done < manuel.env
#else
#    echo "Error: .env file not found"
#    exit 1
#fi

if [ -f manuel.env ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ $line =~ ^[^#] ]]; then
            # İlk eşittir işaretini bul ve ona göre böl
            key="${line%%=*}"
            value="${line#*=}"
            
            # Değerdeki baştaki ve sondaki çift tırnakları kaldır
            value="${value#\"}"
            value="${value%\"}"
            
            # Export et
            export "$key=$value"
        fi
    done < manuel.env
else
    echo "Error: .env file not found"
    exit 1
fi

cd /workspace/Desktop/Grand.Installer.Cli

dotnet Grand.Installer.Cli.dll