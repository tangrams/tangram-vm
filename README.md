vector-map-vm
=============

A Vagrant VM for setting up and running vector-map (https://github.com/bcamper/vector-map).

Live public demo: <http://vector.io/vector-map>

![vector-map render of lower Manhattan](https://pbs.twimg.com/media/BpuBdL_CEAAhpWw.png:large)

###Requirements:

- VirtualBox (https://www.virtualbox.org/)
- Vagrant (https://www.vagrantup.com/downloads.html)

=============

###vector-map vm setup

After cloning this repository and starting a terminal window inside the directory, the steps below will provision the VM. Eventually this will be automated with Puppet.

    # start the VM
    vagrant up
    vagrant ssh

    # install curl and pip
    sudo apt-get update
    sudo apt-get -y install curl
    curl -O -L https://raw.github.com/pypa/pip/master/contrib/get-pip.py
    sudo python get-pip.py

    # install postgresql and postgis
    sudo apt-get -y install python-software-properties
    sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable

    echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" | sudo tee /etc/apt/sources.list.d/postgis.list
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update && sudo apt-get -y install libgdal1 postgresql-9.3 postgresql-9.3-postgis-2.1 postgresql-client-9.3

    sudo apt-get -y install protobuf-compiler libprotobuf-c0-dev protobuf-c-compiler

    sudo aptitude -y install build-essential python-dev libprotobuf-dev libtokyocabinet-dev python-psycopg2 libgeos-c1

    # create the db and user
    sudo su -p - postgres -c "createuser osm -s -d"
    sudo su -p - postgres -c "createdb -O osm osm"

Edit `/etc/postgresql/9.3/main/pg_hba.conf` (probably have to use vi, sorry) and change the METHOD for these two lines to "trust":

    # "local" is for Unix domain socket connections only
    local   all             all                                     trust
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            trust

Then save the file and:

    sudo service postgresql restart

    # install postgresql extensions
    sudo apt-get -y install postgresql-contrib

    sudo su -p - postgres -c 'psql -d osm -c "CREATE EXTENSION hstore;"'
    sudo su -p - postgres -c 'psql -d osm -c "CREATE EXTENSION adminpack;"'
    sudo su -p - postgres -c 'psql -d osm -c "CREATE EXTENSION postgis;"'

    # install git and get the datasource
    sudo apt-get -y install git-core

    # if you are on Windows, you may need to start the ssh-agent service to enable
    # ssh forwarding every time you start a new bash session: 
    # http://stackoverflow.com/questions/3669001/getting-ssh-agent-to-work-with-git-run-from-windows-command-shell/15870387#15870387
    
    git clone git@github.com:meetar/vector-datasource.git

    # get and make osm2pgsql from source
    git clone git://github.com/openstreetmap/osm2pgsql.git
    cd osm2pgsql

    sudo apt-get -y install -y dh-autoreconf libxml2-dev libbz2-dev libgeos-dev libproj-dev libpq-dev libgeos++-dev

    ./autogen.sh && ./configure && make
    export PATH=$PATH:`pwd`

    cd ~/vector-datasource

    # get and load the new york extract into the db
    curl -O https://s3.amazonaws.com/metro-extracts.mapzen.com/new-york.osm.pbf

    osm2pgsql -d osm -U osm --slim --style osm2pgsql.style --hstore new-york.osm.pbf --cache-strategy sparse

    sudo pip install --allow-external PIL --allow-unverified PIL PIL modestmaps simplejson werkzeug

    sudo pip install Shapely

    sudo apt-get install -y unzip

    # download the files in fileslist.txt and load them into the db
    bash download.sh
    bash shp2pgsql.sh | psql -U osm -d osm

    # get, install, and start the TileStache server
    cd ~
    git clone git@github.com:TileStache/TileStache.git
    cd TileStache
    sudo python setup.py install
    ./scripts/tilestache-server.py -c ../vector-datasource/tilestache.cfg -i 0.0.0.0

In a new terminal window, get the vector-map repo and start the HTTP server (Windows reminder: you'll need to restart the ssh-agent if you start a new bash session):

    vagrant ssh
    git clone git@github.com:bcamper/vector-map.git
    cd vector-map
    python -m SimpleHTTPServer 9000

In a browser: <http://localhost:9000/#mapzen-local,40.70519687658815,-74.01049375534059,16>
