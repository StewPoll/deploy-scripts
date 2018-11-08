if __name__ == '__main__':
    php_config = ''
    print('Opening file')
    with open('/etc/php/7.2/fpm/php.ini') as config_file:
        data = config_file.readlines()
        for line in data:
            php_config += line

    print('File opened')

    print('Updating lines')
    php_config = php_config.replace(';cgi.fix_pathinfo=1','cgi.fix_pathinfo=0')                 # Security... something?
    php_config = php_config.replace('upload_max_filesize = 2M', 'upload_max_filesize = 50M')    # Uploading themes
    php_config = php_config.replace('post_max_size  = 8M', 'post_max_size  = 55M')              # Uploading themes
    php_config = php_config.replace('memory_limit = 128M', 'memory_limit = 256M')               # Just cause

    print('Saving config file')
    with open('/etc/php/7.0/fpm/php.ini', 'w+') as config_file:
        config_file.writelines(php_config)

    print('Config Updated')
    exit()