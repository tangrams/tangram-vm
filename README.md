vector-map-vm
=============

A Vagrant VM for setting up and running vector-map (https://github.com/bcamper/vector-map).

Live public demo: <http://vector-map.mapzen.com>

![vector-map render of lower Manhattan](https://pbs.twimg.com/media/BpuBdL_CEAAhpWw.png:large)

###Requirements:

- VirtualBox (https://www.virtualbox.org/)
- Vagrant (https://www.vagrantup.com/downloads.html)

=============

###vector-map vm setup

After cloning this repository and starting a terminal window inside the directory, the steps below will provision the VM.

    # start the VM
    vagrant up
    vagrant ssh

    # navigate to the shared directory and run the first install script
    cd /vagrant
    bash install1.sh

    # open a new terminal window, ssh back into the vm, and run the second script
    vagrant ssh
    cd /vagrant
    bash install2.sh

Test the setup in a browser: <http://localhost:9000/#mapzen>

Note for Windows users: you may need to start the ssh-agent for each new bash session in order for git authentication to work. From outside the vm, run:

    eval `ssh-agent -s` 
    ssh-add ~/.ssh/*_rsa

See http://stackoverflow.com/a/19792331/738675

