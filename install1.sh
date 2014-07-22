#!bin/bash

#
# Step 1
#

# test github ssh permissions
ssh -vT git@github.com
if [ $? != 1 ]; then
  echo "* ERROR: Github authentication failed!"
  echo "Please make sure your permissions are in order:"
  echo "https://help.github.com/articles/error-permission-denied-publickey"
  echo "Windows users: please make sure your ssh-agent is running:"
  echo "http://stackoverflow.com/a/19792331/738675"
  exit
fi


# # install curl and pip
sudo apt-get update
sudo apt-get -y install curl
curl -O -L https://raw.github.com/pypa/pip/master/contrib/get-pip.py
sudo python get-pip.py

# # add various requirements
sudo apt-get -y install protobuf-compiler libprotobuf-c0-dev protobuf-c-compiler git-core

# install mapnik
sudo apt-get -y install python-software-properties
echo 'yes' | sudo add-apt-repository ppa:mapnik/v2.1.0
sudo apt-get update
# install core mapnik
sudo apt-get install -y libmapnik mapnik-utils python-mapnik
# install the python binding
sudo apt-get install -y python-mapnik


sudo aptitude -y install build-essential python-dev libprotobuf-dev libtokyocabinet-dev python-psycopg2 libgeos-c1

# If you are on Windows, you may need to start the ssh-agent service
# to enable ssh forwarding every time you start a new bash session,
# so the git ssh authentication will work
# http://stackoverflow.com/questions/3669001/getting-ssh-agent-to-work-with-git-run-from-windows-command-shell/15870387#15870387

# install more requirements
sudo pip install --allow-external PIL --allow-unverified PIL PIL modestmaps simplejson werkzeug Shapely

# get, install, and start the TileStache server
cd ~
git clone git@github.com:TileStache/TileStache.git
cd TileStache
sudo python setup.py install
echo "\nStarting TileStache server -- next, open a new window in the vector-map-vm directory,\n 'vagrant ssh', 'cd /vagrant', and 'bash install2.sh'"
./scripts/tilestache-server.py -c tilestache.cfg -i 0.0.0.0

# End of step 1!
