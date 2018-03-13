#!/usr/bin/env bash

cd /home/appuser; git clone -b infra-2 https://github.com/Otus-DevOps-2017-11/azorge_infra.git 
cd azorge_infra
bash install_ruby.sh
bash install_mongodb.sh
bash deploy.sh
