provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata" "ssh-keys" {
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}appuser3:${file(var.public_key_path)}"
  }
}

resource "google_compute_instance" "app" {
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]
  count        = "${var.number_of_nodes}"
  name         = "reddit-app-${count.index}"

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["reddit-app"]
}

resource "google_compute_instance_group" "puma-backends" {
  name = "puma-reddit-backends"
  zone = "${var.zone}"

  instances = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "puma-http"
    port = "9292"
  }
}

resource "google_compute_http_health_check" "puma-http-healthcheck" {
  name               = "reddit-puma-http-healthcheck"
  port               = "9292"
  request_path       = "/"
  check_interval_sec = 3
  timeout_sec        = 2
}

resource "google_compute_backend_service" "puma-backend-lb" {
  name        = "reddit-puma-backend-lb"
  protocol    = "HTTP"
  timeout_sec = 10
  port_name   = "puma-http"

  #session_affinity = "CLIENT_IP"

  backend {
    group = "${google_compute_instance_group.puma-backends.self_link}"
  }
  # Define created healthcheck
  health_checks = ["${google_compute_http_health_check.puma-http-healthcheck.self_link}"]
}

resource "google_compute_url_map" "puma-url-map" {
  name            = "reddit-puma-url-map"
  default_service = "${google_compute_backend_service.puma-backend-lb.self_link}"
}

resource "google_compute_target_http_proxy" "puma-http-proxy" {
  name    = "reddit-puma-http-proxy"
  url_map = "${google_compute_url_map.puma-url-map.self_link}"
}

resource "google_compute_global_forwarding_rule" "puma-fwd-rule" {
  name       = "reddit-puma-forwarding-rule"
  target     = "${google_compute_target_http_proxy.puma-http-proxy.self_link}"
  port_range = "80"
}
