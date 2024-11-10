wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
mongosh --port 27016

use fl1rpo1nt

db.createUser({
  user: "admin",
  pwd: "Aa123456$",
  roles: [
    { role: "readWrite", db: "fl1rpo1nt" }
  ]
})


sudo nano /etc/mongod.conf
systemctl restart mongod
sudo ufw allow 27017