#provider "vultr" {
#	api_key = "TODO_SET_TO_YOUR_API_KEY__OR__THE_VULTR_API_KEY_ENV_VARIABLE"
#}

resource "vultr_ssh_key" "example" {
	name = "example created from terraform"

	# get the public key from a local file.
	#
	# create the example_rsa.pub file with:
	#
	#	ssh-keygen -t rsa -b 4096 -C 'terraform example' -f example_rsa -N ''
	public_key = "${file("example_rsa.pub")}"
}

resource "vultr_server" "example" {
	name = "example created from terraform"
	
	# set the hostname.
	# Optional value.
	hostname = "foobar.example.com"

	# set Vultr tags
	# Optional value.
	tag = "exampletag"	

	# set the region. 7 is Amsterdam.
	# View the list of regions with the command: vultr regions
	region_id = 7

	# set the plan. 29 is 768 MB RAM,15 GB SSD,1.00 TB BW.
	# View the list of plans with the command: vultr plans --region 7
	plan_id = 29

	# set the OS image. 179 is CoreOS Stable.
	# View the list of OSs with the command: vultr os
	os_id = 179
	
	# Enable or disable Auto Backups
	# Optional value.
	auto_backups = false

        # Specify Snapshot ID
        # If this value is set os_id must equal 164, otherwise terraform apply will fail.
	# Optional value
        # View the list of snapshots with the command: vultr snapshots
        # snapshot_id = ""
 
        # Specify Application ID
        # If this value is set os_id must equal 186, otherwise terraform apply will fail.
	# Optional value
        # View the list of snapshots with the command: vultr apps
	# app_id = ""

	# enable IPv6.
	ipv6 = true

	# enable private networking.
	private_networking = true

	# enable one or more ssh keys on the root account.
	ssh_key_ids = ["${vultr_ssh_key.example.id}"]

	# cloud-init user data
	# See https://www.vultr.com/docs/getting-started-with-cloud-init
	#     http://cloudinit.readthedocs.io/en/latest/index.html
	# Optional value	
	user_data = "${file("userdata.init")}"

	# Run a Vultr script. 
	# Optional value.
	# View the scripts with the command: vultr scripts
	# script = 123456

	# execute a command on the local machine.
	provisioner "local-exec" {
        command = "echo local-exec ${vultr_server.example.ipv4_address}"
	}

	# execute commands on the remote machine.
	provisioner "remote-exec" {
        inline = [
			"env",
			"ip addr",
		]
	}
}
