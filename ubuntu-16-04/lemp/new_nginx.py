import sys
if __name__ == '__main__':
    args = sys.argv[1:]

    site_name = args[1]

    # Gotta stitch them domains up!
    domains = ' '.join(args[2:])

    config = ''
    with open('default_nginx') as default_file:
        reader = default_file.readlines()
        for line in reader:
            config += line

    # As NGINX has the { } config setup inside it, it messes with the ability to do .format and this makes me sad...
    config = config.replace('{root_path}', args[0])
    config = config.replace('{log_path}', '/var/log/' + site_name)
    config = config.replace('{domains}', domains)

    with open(site_name, 'w') as new_file:
        new_file.write(config)

    exit()
