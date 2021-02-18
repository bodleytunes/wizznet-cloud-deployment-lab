locals {
  plex_ip       = "10.0.0.10"
  plex_hostname = "plex"
}

resource "proxmox_vm_qemu" "plex_media_server" {

  vmid        = 0
  name        = "plex"
  target_node = "p20"
  clone       = "ubuntu-cloudinit-9003"
  agent       = 1
  # custom cloud init file located on proxmox host in snippets dir
  cicustom = "user=local:snippets/user-data-cicustom.yaml"


  cores   = 4
  sockets = 1
  memory  = 4096

  ipconfig0  = "ip=10.0.0.10/24,gw=10.0.0.1"
  nameserver = "9.9.9.9"
  ciuser     = "jon"

  sshkeys = <<EOF
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjM78UyIQWNbMsca2qafeshPflijH8HbbsKuTTZqB1F jon@DESKTOP-SNM4E2E
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlAs2ApLH1sTfDTfYvFDcDS5cyAdkCqcJ28D+4Lpuyo jon@troon
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpASWQUj+UkSv2M4kgxMEeM3oUYtKI54N1CVnwKrk9A root@salt
EOF

  disk {
    size      = "15G"
    type      = "scsi"
    storage   = "zfs1"
    replicate = true
  }

  network {
    model  = "virtio"
    bridge = "evpn100"
  }


  # basic remote execution script 
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${local.plex_hostname}",
      "sudo echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf",
      "sudo sysctl -p",
      "sudo wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sudo chmod 700 bootstrap-salt.sh",
      "sudo ./bootstrap-salt.sh -A 10.12.7.149",
    ]
    connection {
      private_key = file(var.ssh_private_key)
      host        = local.plex_ip
      user        = "jon"
    }
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

}