#provider "openstack" {
#  user_name   = "Gorantla.Krishna"
#  tenant_name = "Jiocloud-NonProduction"
#  password    = "Kri$hna09333"
#  auth_url    = "https://10.157.11.80:5000/v2.0"
#  insecure    = "true"
# }
#resource "openstack_compute_instance_v2" "Terraform-test" {
#         name = "Terraform-test"
#         image_id = "37820301-fbb5-4ee2-8284-f4ec5b71c5ee"
#         flavor_name = "m1.large"
#         key_pair = "JC_PP_Key"
#         security_groups = ["default"]

#         network = {
#		 name = "JC-LT-SN-01"
#         }

#}
#resource "openstack_networking_floatingip_v2" "fip_1" {
#    pool = "ext-net-nonprod2"
#}

#resource "openstack_compute_floatingip_associate_v2" "fip_1" {
#  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
#  instance_id = "${openstack_compute_instance_v2.Terraform-test.id}"
#}

###############################################################################################################

provider "openstack" {
  user_name   = "${var.openstack_user_name}"
  tenant_name = "${var.openstack_tenant_name}"
  password    = "${var.openstack_password}"
  auth_url    = "${var.openstack_auth_url}"
  insecure    = "true"
}

resource "openstack_networking_network_v2" "Terraform" {
  name           = "${var.Network_name}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "Terraform_test_subnet" {
  name       = "Test_subnet"
  network_id = "${openstack_networking_network_v2.Terraform.id}"
  cidr       = "172.25.60.0/24"
  ip_version = 4
}
resource "openstack_compute_secgroup_v2" "secgroup_test" {
  name        = "secgroup_test"
  description = "my security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "Terraform_test_count" {
  count           = "${var.count}"
  name            = "${var.Name_Prefix}-${format("${var.instance_name}-%02d", count.index+1)}"
  flavor_name     = "${var.Instance_Type}"
  key_pair        = "${var.Key_Pair}"
  security_groups = ["default" , "secgroup_test"]
  image_name      = "${var.Image}"

#    provisioner "local-exec" {
#      command = "sleep 30 && echo -e \"[webserver]\n${element(openstack_networking_floatingip_v2.fip_1.*.address, count.index+1)} ansible_connection=ssh ansible_ssh_user=cloud-user\" > inventory && ansible-playbook -i inventory playbook.yml"
#    }

  #  provisioner "local-exec" { 
  #   command = "sleep 30 && ansible-playbook -i hosts playbook.yml"
  #}
  network = {
    name = "${var.Network_name}"
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  count = "${var.count}"
  pool  = "ext-net-nonprod2"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  count       = "${var.count}"
  floating_ip = "${element(openstack_networking_floatingip_v2.fip_1.*.address, count.index+1)}"
  instance_id = "${element(openstack_compute_instance_v2.Terraform_test_count.*.id, count.index+1)}"
}

#resource "null_resource" "foo_provisioning" {

#  provisioner "local-exec" {
#     command = <<EOD
#cat <<EOF  > hosts
#[test]
#${join("\n",openstack_compute_instance_v2.Terraform_test_count.*.access_ip_v4)}
#EOF
#EOD

     
#  }

#   provisioner "local-exec" {
#    command = "sleep 30 && ansible-playbook -u cloud-user --private-key ~/terraform/openstack/key.pem -i hosts playbook.yml"
#}
#}



#resource "openstack_blockstorage_volume_v1" "volume_1" {
#  region      = "RegionOne"
#  name        = "tf-test-volume"
#  description = "first test volume"
#  size        = 30
#}

# provisioner "local-exec" {
#      command = "sleep 30 && echo -e \"[webserver]\n${lookup("\n",openstack_compute_instance_v2.Terraform_test_count.*.access_ip_v4[count.index])} ansible_connection=ssh ansible_ssh_user=cloud-user\" > inventory " #&& ansible-playbook -i inventory playbook.yml"
#    }

#}


resource "openstack_compute_instance_v2" "Terraform_test_count_round" {
  count           = "2"
  name            = "${var.Name_Prefix}-${format("${var.instance_name}-%02d", count.index+1)}"
  flavor_name     = "${var.Instance_Type}"
  key_pair        = "${var.Key_Pair}"
  security_groups = ["default" , "secgroup_test"]
  image_name      = "${var.Image}"

#    provisioner "local-exec" {
#      command = "sleep 30 && echo -e \"[webserver]\n${element(openstack_networking_floatingip_v2.fip_1.*.address, count.index+1)} ansible_connection=ssh ansible_ssh_user=cloud-user\" > inventory && ansible-playbook -i inventory playbook.yml"
#    }

  #  provisioner "local-exec" {
  #   command = "sleep 30 && ansible-playbook -i hosts playbook.yml"
  #}
  network = {
    name = "${var.Network_name}"
  }
}

resource "openstack_networking_floatingip_v2" "fip_2" {
  count = "2"
  pool  = "ext-net-nonprod2"
}

resource "openstack_compute_floatingip_associate_v2" "fip_2" {
  count       = "2"
  floating_ip = "${element(openstack_networking_floatingip_v2.fip_2.*.address, count.index+1)}"
  instance_id = "${element(openstack_compute_instance_v2.Terraform_test_count_round.*.id, count.index+1)}"
}

resource "null_resource" "foo_provisioning" {

  provisioner "local-exec" {
     command = <<EOD
cat <<EOF  > hosts
[test]
${join("\n",openstack_compute_instance_v2.Terraform_test_count.*.access_ip_v4)}
[round]
${join("\n",openstack_compute_instance_v2.Terraform_test_count_round.*.access_ip_v4)}
EOF
EOD


  }

#   provisioner "local-exec" {
#    command = "sleep 30 && ansible-playbook -u cloud-user --private-key ~/terraform/openstack/key.pem -i hosts playbook.yml"
#}
}

