
provider "google" {
  credentials = "${file("/path/to/private/gcp/project/key.json")}"
  project     = "seminario-devops"
  region      = "us-east1-b"
}

resource "google_compute_instance" "worker" {
 project = "seminario-devops"
 zone = "us-east1-b"
 name = "terraform-test"
 machine_type = "n1-standard-1"

 tags = ["jenkins", "cloudera", "http", "https"]
 
 boot_disk {
   initialize_params {
     image = "centos-7-v20171213"
     size = "10"
   }
 }
 
 network_interface {
   network = "default"
   access_config {
   }
 }

 provisioner "local-exec" { 
  #command = "sleep 90; ansible-playbook -i '${google_compute_instance.worker.name},' --private-key=~/.ssh/ansible_rsa /opt/ansible/worker.yml -e 'ansible_ssh_user=dario_pasquali93' -e 'host_key_checking=False'"
  command = "sleep 90; ansible -i '${google_compute_instance.worker.name},' --private-key=~/.ssh/ansible_rsa -m ping -e 'ansible_ssh_user=dario_pasquali93' -e 'host_key_checking=False'"
 }
}

output "worker" {
 value = "${google_compute_instance.worker.self_link}"
}
