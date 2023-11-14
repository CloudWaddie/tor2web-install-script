echo "Updating Repositories"
echo ""
echo ""
echo ""
apt-get update
apt-get upgrade

dir=$(pwd)


echo "Running Tor2Web Install Script"
./install-tor2web.sh

echo "Generating Certificates"
echo ""
echo ""
echo ""
echo ""
cd /home/tor2web/certs/
openssl genrsa -out tor2web-key.pem 4096
openssl req -new -key tor2web-key.pem -out tor2web-csr.pem -batch
openssl x509 -req -days 365 -in tor2web-csr.pem -signkey tor2web-key.pem -out tor2web-cert.pem

echo ""
echo ""
echo ""
echo ""
echo "Done!"
cd $dir
cp /usr/share/tor2web/data/conf/tor2web-default.conf ./config.conf
echo "Now follow next.MD to configure Tor2Web"

# Wait for user input
read -s -r -p "Press enter to continue..."

cp ./config.conf /etc/tor2web.conf