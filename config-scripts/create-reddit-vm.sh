#!/usr/bin/env bash

gcloud compute instances create reddit-app  --boot-disk-size=10GB --image-family=reddit-full --tags "default-puma-server" --preemptible  --restart-on-failure