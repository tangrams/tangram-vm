#!bin/bash
git clone git@github.com:bcamper/tangram.git
cd tangram
sudo npm install
make
echo -e "\n Starting web server -- test it at http://localhost:9000/#mapzen"
python -m SimpleHTTPServer 9000
