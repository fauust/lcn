# 1. Iteration 1
    
##    1. Installation de Docker et révision.
    
    Docker installation could be performed simply by running some commands (i) but I am going to do it with Ansible (ii)

###         i. Installing with a shell script

A Docker installa tion script is available at : [scripts/installDocker.sh](scripts/installDocker.sh)

###         ii. Installation with an Ansible role


##    2. Container simple et datas

Last time I was really into shell scripting, so I created an Apache container with a [shell script](scripts/firstContainer.sh).

I will now do it with a [docker file](dockerFiles/apacheHelloworld/Dockerfile
)