locals {
    machine_types = {
    # Recommended VMs with cost / month
    # Use N2, N2D or C2: sustained use discounts upto 20%
    # N2D is often cheaper, unless Intel CPU is required 
    n2d_2cpu_8gb    = "n2d-standard-2",  # $76.09082
    n2d_2cpu_16gb   = "n2d-highmem-2",   # $102.6453
    n2d_4cpu_4gb    = "n2d-highcpu-4",   # $112.34992
    n2d_4cpu_16gb   = "n2d-standard-4",  # $152.18164
    n2d_4cpu_32gb   = "n2d-highmem-4",   # $205.2906
    n2d_8cpu_8gb    = "n2d-highcpu-8",   # $224.69984
    n2d_8cpu_32gb   = "n2d-standard-8",  # $304.36328
    n2d_8cpu_64gb   = "n2d-highmem-8",   # $410.5806
    n2d_16cpu_16gb  = "n2d-highcpu-16",  # $449.39968
    n2d_16cpu_128gb = "n2d-highmem-16",  # $821.1624
    n2d_32cpu_32gb  = "n2d-highcpu-32",  # $898.79936
    n2d_32cpu_128gb = "n2d-standard-32", # $1219.45312
    n2d_32cpu_256gb = "n2d-highmem-32",  # $1642.3248
    n2d_48cpu_48gb  = "n2d-highcpu-48",  # $1348.19968
    n2d_64cpu_64gb  = "n2d-highcpu-64",  # $1797.59952

    n2_2cpu_16gb   = "n2-highmem-2",   # $117.97822
    n2_4cpu_16gb   = "n2-standard-4",  # $174.91676
    n2_4cpu_32gb   = "n2-highmem-4",   # $235.95644
    n2_8cpu_8gb    = "n2-highcpu-8",   # $258.274
    n2_8cpu_32gb   = "n2-standard-8",  # $349.83352
    n2_16cpu_16gb  = "n2-highcpu-16",  # $516.548
    n2_16cpu_64gb  = "n2-standard-16", # $699.66704
    n2_16cpu_128gb = "n2-highmem-16",  # $943.82576
    n2_32cpu_32gb  = "n2-highcpu-32",  # $1033.096
    n2_32cpu_128gb = "n2-standard-32", # $1399.33408
    n2_32cpu_256gb = "n2-highmem-32",  # $1887.65152
  }
}

resource "google_compute_instance" "vm1" {
  name         = "vm1"
  machine_type = local.machine_types.n2d_8cpu_32gb
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian12.self_link
      size  = 200
      type  = "pd-ssd"
    }
  }

  metadata                = {}
  metadata_startup_script = "sudo apt update"

  network_interface {
    subnetwork = google_compute_subnetwork.main.id
    access_config {
      nat_ip = google_compute_address.address-1.address
    }
  }

  can_ip_forward            = true
  allow_stopping_for_update = true
}


