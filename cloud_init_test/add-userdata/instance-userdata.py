import time, os, sys
import inspect
from os import environ as env

from  novaclient import client
import keystoneclient.v3.client as ksclient
from keystoneauth1 import loading
from keystoneauth1 import session

def contextualizeVM(instanceName):

    flavor = "m1.small" 
    private_net = "g2015034-net_2"
    floating_ip_pool_name = "public"
    floating_ip = None

    loader = loading.get_plugin_loader('password')
    auth = loader.load_from_options(auth_url=env['OS_AUTH_URL'],
                                    username=env['OS_USERNAME'],
                                    password=env['OS_PASSWORD'],
                                    project_name=env['OS_PROJECT_NAME'],
                                    user_domain_name=env['OS_USER_DOMAIN_NAME'],
                                    project_domain_name=env['OS_PROJECT_DOMAIN_NAME'])


    sess = session.Session(auth=auth)
    nova = client.Client('2.1', session=sess)
    print "user authorization completed."

    #image = nova.images.find(name="Ubuntu-16.04")
    image = nova.images.find(id="6096f4bb-cc53-40a5-a291-4e49668de70a")
    flavor = nova.flavors.find(name=flavor)

    if private_net != None:
        net = nova.networks.find(label=private_net)
        nics = [{'net-id': net.id}]
    else:
        sys.exit("private-net not defined.")

    #print("Path at terminal when executing this file")
    #print(os.getcwd() + "\n")
    cfg_file_path =  os.getcwd()+'/cloud-cfg_test.txt'
    if os.path.isfile(cfg_file_path):
        userdata = open(cfg_file_path)
    else:
        sys.exit("cloud-cfg.txt is not in current working directory")
    
    secgroup = nova.security_groups.find(name="Group2")
    secgroups = [secgroup.id]

    #floating_ip = nova.floating_ips.create(nova.floating_ip_pools.list()[0].name)

    if floating_ip_pool_name != None: 
        floating_ip = nova.floating_ips.create(floating_ip_pool_name)
    else: 
        sys.exit("public ip pool name not defined.")


    print "Creating instance ... "
    #instance = nova.servers.create(name="majae_dist", image=image, flavor=flavor, key_name="majae_keypair_2", nics=nics,security_groups=secgroups)
    instance = nova.servers.create(name=instanceName, image=image, flavor=flavor, userdata=userdata, key_name="grupp2_keypair", nics=nics,security_groups=secgroups)
    inst_status = instance.status
    print "waiting for 10 seconds.. "
    time.sleep(10)

    while inst_status == 'BUILD':
        print "Instance: "+instance.name+" is in "+inst_status+" state, sleeping for 5 seconds more..."
        time.sleep(5)
        instance = nova.servers.get(instance.id)
        inst_status = instance.status
        
    print "Instance: "+ instance.name +" is in " + inst_status + "state"
                    
    if floating_ip.ip != None: 
        instance.add_floating_ip(floating_ip)
        print "Instance booted! Name: " + instance.name + " Status: " +instance.status+ ", floating IP attached " + floating_ip.ip
    else:
        print "Instance booted! Name: " + instance.name + " Status: " +instance.status+ ", floating IP missing"
                        
