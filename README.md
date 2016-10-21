Readme:
# BaaS (BENCHCHOP as a Service)
The purpose of this project is to investigate the outcome of moving Benchop to a Cloud environment as BENCHCHOP as a Service (BaaS) with the following question in focus:
- Can you speed up the evaluation of the benchmark by running different solvers in parallel in the backend?

#QUICK SETUP

- Create an account on cloud.snic.se
- Clone this repository.
- Use the cloud init file “cloud-cfg_master_node.txt” in “BaaS/cloud_init_test/add-userdata” to boot a master node instance with the webserver. 
- Create a key-pair at cloud.snic.se and add it to the instance. 
- Use security-group “Group2” or create a separate one where port 22(SSH), 5000(web-app), 5555(flower) and 5672(RabbitMQ) are open. 
- During the initialization of the master node, a bash script will be downloaded and executed, starting the webserver. If this process fails, the user has to ssh into the VM and manually run the commands in the bash script found in “startup_script_master” located in “BaaS/cloud_init_test/add-userdata”.
- Go to http://docs.openstack.org/cli-reference/common/cli_install_openstack_command_line_clients.html and download the OpenStack-client API.
- Download the Runtime Configuration (RC) file from the SSC site (Project->Compute->Access & Security->API Access->Download OpenStack RC File).
- Confirm that your RC file have following environment variables:
- export OS_USER_DOMAIN_NAME="Default"
- export OS_IDENTITY_API_VERSION="3"
- export OS_PROJECT_DOMAIN_NAME="Default"
- Set the environment variables by sourcing the RC-file:
     $ source <project_name>_openrc.sh

#The webserver can be started with the following commands: 
- Go to folder /home/ubuntu/BaaS/webserver on the master node
- Start python script with the following command: python run_task.py
- Go to folder /home/ubuntu/BaaS/webserver/node_webserver
- Run command: node webserver.js
- The webserver should now be running

- Go to <master-nodes-ip>:5000 via your browser to use the web interface.
- Create a request and wait until workers are running.
- Go to <master-nodes-ip>:5555 to see status of workers.
- After the workers are finished, the results including graphs of the result will be presented at <master-nodes-ip>:5000.
