#!bin/bash
git clone git@github.com:meetar/tangram.git
cd tangram
echo -e "\n Starting web server -- test it at http://localhost:9000/#mapzen"
python -m SimpleHTTPServer 9000
