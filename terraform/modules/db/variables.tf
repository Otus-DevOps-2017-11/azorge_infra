variable db_disk_image {
  description = "Disk image for reddit data base"
  default     = "reddit-db-base"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the file with the list of public keys used for ssh access"
}
