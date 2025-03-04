Docker Installation
=========

This role installs Docker on Ubuntu/Debian or Arch/Manjaro Linux, then starts and enables the Docker service.

Dependencies
------------

- [`community.general.pacman`](https://docs.ansible.com/ansible/latest/collections/community/general/pacman_module.html)

Example Playbook
----------------

```YAML
---
- name: VM setup
  hosts: all
  become: true
  roles:
    - install_docker

```

License
-------

BSD

Author Information
------------------

[0xtr1gger](https://github.com/0xtr1gger)
