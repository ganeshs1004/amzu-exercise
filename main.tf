# Provider Configuration
provider "google" {
  project = "amzu-exercise"
  region  = "us-central1"
}

# Resources
resource "google_compute_network" "network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  region        = "us-central1"
  network       = google_compute_network.network.name
  ip_cidr_range = "10.0.0.0/24"
}

# Create firewall rule for SSH access
resource "google_compute_firewall" "ssh_fw_rule" {
  name    = "ssh-fw-rule"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["ssh"]
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# Create firewall rule for port 8080
resource "google_compute_firewall" "web_app_fw_rule" {
  name    = "web-app-fw-rule"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["web-app"]
}

# Create firewall rule for ICMP (ping) traffic
resource "google_compute_firewall" "icmp_fw_rule" {
  name    = "icmp-fw-rule"
  network = google_compute_network.network.self_link

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["icmp"]
}

resource "google_compute_instance" "web_application" {
  name         = "web-application"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      // Public IP configuration for web-application
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    # Add user access to VM
    echo "user1@example.com" >> /opt/users.txt
    echo "user2@example.com" >> /opt/users.txt
  EOT
 # Install Apache
    apt-get update
    apt-get install -y apache2

    # Configure Apache
    echo "<h1>Welcome to My Web Service</h1>" > /var/www/html/index.html
  EOT
  tags = ["web-app", "ssh"]
}

resource "google_compute_instance" "web_service_1" {
  name         = "web-service-1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    # Add user access to VM
    echo "user1@example.com" >> /opt/users.txt
    echo "user2@example.com" >> /opt/users.txt
  EOT

  tags = ["web-app", "ssh"]
}

resource "google_compute_instance" "web_service_2" {
  name         = "web-service-2"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    # Add user access to VM
    echo "user1@example.com" >> /opt/users.txt
    echo "user2@example.com" >> /opt/users.txt
  EOT

  tags = ["web-app", "ssh"]
}

# Output
output "public_ip_address" {
  value = google_compute_instance.web_application.network_interface[0].access_config[0].nat_ip
}

