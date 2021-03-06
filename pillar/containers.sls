containers:
  cn_list:
    - name: plex
      ip: 10.0.198.2
      mask: /24
      network: metallb198
      mtu: 1350
      fw_rules:
        - name: plex_media_server_rancher
          chain: PREROUTING
          ingress_interface: vmbr0
          src: any
          dst: 10.0.198.2
          dst_port: 32401
          dst_port_natted: 32400
          proto: tcp
          type: DNAT
