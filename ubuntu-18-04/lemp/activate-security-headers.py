import sys


# This file looks for the commented out settings in the NGINX configuration, and activates them.
# Check out what I'm doing here: https://securityheaders.io/
if __name__ == '__main__':
    nginx_conf_path = '/etc/nginx/sites-available/' + sys.argv[1]

    conf = ''
    with open(nginx_conf_path) as conf_file:
        reader = conf_file.readlines()
        for line in reader:
            conf += line
    conf = conf.replace('# add_header', 'add_header')

    with open(nginx_conf_path, 'w+') as new_file:
        new_file.write(conf)

    sys.exit()