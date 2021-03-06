virtual_machines:
  vm_list:
    - name: plex
      ip: 10.0.0.10
      mask: /24
      network: evpn100
      mtu: 1350
      fw_rules:
        - name: plex_media_server
          chain: PREROUTING
          ingress_interface: vmbr0
          src: any
          dst: 10.169.169.100
          dst_port: 32400
          proto: tcp
          type: DNAT
