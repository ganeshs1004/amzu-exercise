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
}

# Output
output "public_ip_address" {
  value = google_compute_instance.web_application.network_interface[0].access_config[0].nat_ip
}

