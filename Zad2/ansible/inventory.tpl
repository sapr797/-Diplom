# ansible/inventory.tpl
all:
  hosts:
%{ for host in hosts }
    ${host.name}:
      ansible_host: ${host.internal_ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
%{ endfor }
  children:
    kube_control_plane:
      hosts:
%{ for host in hosts if host.type == "master" }
        ${host.name}:
%{ endfor }
    kube_node:
      hosts:
%{ for host in hosts if host.type == "worker" }
        ${host.name}:
%{ endfor }
    etcd:
      hosts:
%{ for host in hosts if host.type == "master" }
        ${host.name}:
%{ endfor }
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
