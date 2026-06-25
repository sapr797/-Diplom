#!/bin/bash
# scripts/generate_inventory.sh

# Получить IP-адреса ВМ из Terraform
terraform output -json worker_ips > /tmp/worker_ips.json

# Сгенерировать inventory для Ansible
python3 -c "
import json
import sys

with open('/tmp/worker_ips.json') as f:
    workers = json.load(f)

hosts = []
for idx, worker in workers.items():
    hosts.append({
        'name': worker['name'],
        'internal_ip': worker['ip'],  # Если нет публичного IP
        'type': 'worker'
    })

# Добавить мастер (первый worker)
hosts[0]['type'] = 'master'

# Генерация inventory
inventory = 'all:\n  hosts:\n'
for host in hosts:
    inventory += f'    {host["name"]}:\n'
    inventory += f'      ansible_host: {host["internal_ip"]}\n'
    inventory += f'      ansible_user: ubuntu\n'
    inventory += f'      ansible_ssh_private_key_file: ~/.ssh/id_rsa\n'

inventory += '  children:\n'
inventory += '    kube_control_plane:\n      hosts:\n'
for host in hosts:
    if host['type'] == 'master':
        inventory += f'        {host["name"]}:\n'

inventory += '    kube_node:\n      hosts:\n'
for host in hosts:
    if host['type'] == 'worker':
        inventory += f'        {host["name"]}:\n'

print(inventory)
" > ansible/inventory.ini

echo "Inventory generated: ansible/inventory.ini"
