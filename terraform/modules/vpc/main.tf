resource "google_compute_firewall" "firewall_ssh" {
  network     = "default"
  name        = "default-allow-ssh"
  description = "Allow ssh access"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = "${var.source_ranges}"
}
