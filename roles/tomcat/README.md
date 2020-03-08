# Wirecard
## How to use
Following files are the most important files which deployed successfuly on Ubunt 18.04
- tomcat-playbook.yml
- tomcat-dsl.j2
- /etc/ansible/hosts
- $HOME/password.txt

### tomcat-playbook.yml
Let you install one instance, default verion is 9.0.31.
To add instance of other version (7/8), just nedd to copy lines 22 - 27 and paste it after line 28 and then change the parameters.
```bash
---
- name: "tomcat-version-9"
  hosts: ubuntu18
  become: yes
  gather_facts: yes
  remote_user: vagrant
  
  vars:
    tomcat_instances:
      - name: "tomcat-version-9"
        version: 9
        shutdown_port: 8019
        non_ssl_connector_port: 8084
        ssl_connector_port: 8447
        ajp_port: 8013

  roles:
    - tomcat

```

### tomcat-dsl.j2
DSL file which needed to copy in feed project of jenkins to create the 'tomcat-dsl' project which let you to run the required playbook using jenkins.

```bash
job('tomcat-dsl'){
  description('This will start one or more tomcat on the same machine')
 
  parameters {
     choiceParam('Tomcat Verion', ['9 (default)', '8', '7'])
  }
  
 scm {
       git {
            remote {
                github('nasabayat/Wirecard', 'https')
            }
        }
  }
  
  steps {     
        shell("""
        #!/bin/bash
        mv ./* ../../.ansible/roles/tomcat 
        ansible-galaxy install robertdebock.service
        wget https://raw.githubusercontent.com/nasabayat/Wirecard/master/tomcat-playbook.yml        
        """)        

        ansiblePlaybook('tomcat-playbook.yml') {
            inventoryPath('/etc/ansible/hosts')
            colorizedOutput(true)
            additionalParameters('--vault-password-file $HOME/password.txt')                                    
        }
  }
}
```

### /etc/ansible/hosts
Regarding your own hosts file, please change the hosts in tomcat-playbook.yml, currently it's 'ubuntu18', also 'remote_user' needed to be changed to your own remote user.

```bash
- name: "tomcat-version-9"
  hosts: ubuntu18
  become: yes
  gather_facts: yes
  remote_user: vagrant
```

### $HOME/password.txt
password of the remote user which inserted in playbook, should be saved at password.txt file.