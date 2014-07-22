#!bin/bash
git clone git@github.com:meetar/vector-map.git
cd vector-map
echo "\n Starting web server -- test it at http://localhost:9000/#mapzen"
python -m SimpleHTTPServer 9000
