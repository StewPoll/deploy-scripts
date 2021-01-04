import re
import sys
import urllib.request

if __name__ == '__main__':
    args = sys.argv[1:]
    db_name = args[0]
    mysql_user = args[1]
    mysql_pw = args[2]
    config_file = args[3]
    if config_file[-1] != '/':
        config_file += '/'
    config_file += 'wp-config.php'

    config = ''
    with open(config_file) as file:
        reader = file.readlines()
        for line in reader:
            config += line

    # Replace config data with correct table, username and password
    config = config.replace(
        "define('DB_NAME', 'database_name_here');",
        f"define('DB_NAME', '{db_name}');"
    )
    config = config.replace(
        "define('DB_USER', 'username_here');",
        f"define('DB_USER', '{mysql_user}');"
    )
    config = config.replace(
        "define('DB_PASSWORD', 'password_here');",
        f"define('DB_PASSWORD', '{mysql_pw}');\n\ndefine('FS_METHOD', 'direct');"
    )

    new_salts_data = urllib.request.urlopen('https://api.wordpress.org/secret-key/1.1/salt/')
    new_salts = []
    for line in new_salts_data.readlines():
        new_salts.append(line.decode().strip())

    """
    Instead of trying to find each salt, made this more general to ensure that it always finds all slats.
    """
    salts = {}

    for line in new_salts:
        matches = re.search("define\(\'(\w*)\',\s*\'(.*)\'\);", line)
        salts[matches[1]] = {'value': matches[2], 'line': 0}

    config_lines = config.splitlines()
    for line in config_lines:
        matches = re.search("define\(\'(\w*)\',\s*\'(.*)\'\);", line)
        if matches and matches[1] in salts.keys():
            salts[matches[1]]['line'] = config_lines.index(line)

    for key, option in salts.items():
        value = option['value']
        config_lines[option['line']] = "define('{key}', '{value}');"


    with open(config_file, 'w') as new_file:
        new_config = '\n'.join(config_lines)
        new_file.writelines(new_config)
