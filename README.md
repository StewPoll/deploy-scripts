# StewPolley Deploy Scripts
This Repository is designed to assist getting simple Digital Ocean Droplets and AWS Lightsail instances setup quickly 
with the tools needed for you to quickly get websites and web-apps off the ground. 

## Available Scripts
While there are Python scripts in this repository, they are only here for utility. The Bash Scripts are the focus.
### lemp-setup.sh
This script sets up a basic LEMP stack on the server, and sets a randomly generated MySQL Root password. No input is 
needed by the user for this, although saving the password at the end is needed.

In particular, this script does the following:
* Installs PHP
* Installs Python3.6 (mainly for processing scripts)
* Installs NGINX
* Installs MySQL

Input needed: 
* None

Approx Run Time: 2mins

### install-wordpress.sh
This script, surprisingly, installs wordpress! In particular, it automates the following:
* Downloads the latest version of Wordpress and places in a specified folder under `var/www/html`
* Sets up NGINX config to point to the specified wordpress installation
^ Sets up MySQL User for the wp-install
* Configures wp-config.php with database credentials and salts as needed
* Initiates getting an SSL Certificate via Lets Encrypt... because HTTPS is love. HTTPS is life. 

Input needed:
* MySQL Root Password
* Domain/s the new installation will use (for NGINX config) - IE: www.stewpolley.com stewpolley.com
* Folder under `var/www/html` to install this WP installation
* Various other things for LetsEncrypt

Approx Run Time: 2mins

### Anything else?
Gosh I'm only human! More scripts will be added when I write them... or when someone makes a pull request!

## Usage
While Digital Ocean and Lightsail are very similar there's (at least) one minor difference.
* On lightsail, ensure you allow HTTPS traffic in the "Network" tab of the instance before trying to set up Wodrpesss
after Let's encrypt has done it's thing
* On Digital Ocean you'll need to do `sudo ufw allow 443/tcp` before attempting to setup Wordpress

As more scripts are added, more instructions will be added too, of course. 

In general though, using these scripts is pretty simple

1. Create droplet/instance and wait for it to spin up
2. Ensure that firewall for port 443 has been opened!
2. Install the base lemp stack with `curl https://scripts.stewpolley.com/lemp-setup.sh | sh`
3. Save the MySQL Root Password somewhere
4. Decide on input needed for Wordpress mentioned above
5. Install wordpress using `curl https://scripts.stewpolley.com/install-wordpress.sh >> install-wordpress.sh && sh install-wordpress.sh`
5. visit a domain decided upon above to finish the wordpress installation 


## Security concerns
Evidently, if you find a security concern please create an issue. 

## Contributing
If you'd like to contribute, pull requests are welcome... especially if you can remove the python scripts and implement 
them in Bash!