#!/bin/bash

echo "[TASK 1] Inicializate the Rancher"
docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
