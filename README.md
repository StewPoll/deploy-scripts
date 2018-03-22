# StewPolley Deploy Scripts
This Repository is designed to assist getting simple Digital Ocean Droplets and AWS Lightsail instances setup quickly 
with the tools needed for you to quickly get websites and web-apps off the ground. 

## Available Scripts
Please visit https://scripts.stewpolley.com/ to view available scripts and instructions.

## Usage
While Digital Ocean and Lightsail are very similar there's (at least) one minor difference.
* On lightsail, ensure you allow HTTPS traffic in the "Network" tab of the instance before trying to set up Wodrpesss
after Let's encrypt has done it's thing
* On Digital Ocean you'll need to do `sudo ufw allow 443/tcp` before attempting to setup Wordpress

As more scripts are added, more instructions will be added too, of course. 

In general though, using these scripts is pretty simple

1. Create droplet/instance and wait for it to spin up
2. Ensure that firewall for port 443 has been opened!
2. Install the base lemp stack with `curl https://scripts.stewpolley.com/ubuntu-16-04/lemp/initial-setup.sh | sh`
3. Save the MySQL Root Password somewhere
4. Decide on input needed for Wordpress mentioned above
5. Install wordpress using `curl https://scripts.stewpolley.com/ubuntu-16-04/lemp/install-wordpress.sh >> install-wordpress.sh && sh install-wordpress.sh`
5. visit a domain decided upon above to finish the wordpress installation 


## Security concerns
Evidently, if you find a security concern please create an issue. 

## Contributing
If you'd like to contribute, pull requests are welcome... especially if you can remove the python scripts and implement 
them in Bash!
