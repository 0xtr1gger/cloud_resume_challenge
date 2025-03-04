Docker API setup
=========

This role is used to automatically configure an Ubuntu Linux machine and run an API server in a Docker container, launched with Docker Compose. The API is served by Nginx, and the role can be used to configure HTTPS as well. 

Requirements
------------

- [`community.docker`](https://docs.ansible.com/ansible/latest/collections/community/docker/index.html)

Role Variables
--------------

| Variable Name               | Description                                                                    | Default Value                                                                                                            |
| --------------------------- | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `ansible_user_name`         | The user that Ansible will use for operations.                                 | `ansible`                                                                                                                |
| `api_directory`             | The directory where the configuration files will be copied on the target.      | `/app`                                                                                                                   |
| `compose_file_url`          | The URL to the Docker Compose file that will be used to launch the containers. | `https://raw.githubusercontent.com/0xtr1gger/cloud_resume_challenge/refs/heads/main/s  rc/api-server/docker-compose.yml` |
| `api_docker_image`          | Docker image to use for the API server.                                        | `0xtr1gger/visitor_counter_api`                                                                                          |
| `image_version`             | The tag of the Docker image to use.                                            | `v1.0`                                                                                                                   |
| `listen_80`                 | Whether to listen on port `80` or not.                                         | `true`                                                                                                                   |
| `listen_443`                | Whether to listen on port `443` or not.                                        | `true`                                                                                                                   |
| `set_up_tls`                | Whether to configure TLS certificates for HTTPS.                               | `true`                                                                                                                   |
| `domain_name`               | The domain name to be used for the API.                                        | `example.com`                                                                                                            |
| `nginx_proxy_pass`          | The location where the API is exposed for the Nginx proxy.                     | `'http://localhost:5000'`                                                                                                |
| `email_address`             | The email address to be used for Certbot.                                      | `johndoe@example.com`                                                                                                    |
| `certbot_auto_renew_minute` | The minute at which Certbot auto-renewal will run (cron job).                  | `'1'`                                                                                                                    |
| `certbot_auto_renew_hour`   | The hour at which Certbot auto-renewal will run (cron job).                    | `*/12`                                                                                                                   |
| `certbot_auto_renew_user`   | The user under which Certbot will perform auto-renewal.                        | `ansible`                                                                                                                |

Dependencies
------------

- [`community.docker`](https://docs.ansible.com/ansible/latest/collections/community/docker/index.html)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```YAML
---  
- name: VM setup  
 hosts: all  
 become: yes  
 roles:  
   - role: api_setup
     domain_name: 'example.com'
     email_address: 'johndoe@example.com'
```

License
-------

BSD

Author Information
------------------

[0xtr1gger](https://github.com/0xtr1gger)