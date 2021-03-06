# Config
NODE_ID = 0

# hour,set 0 to disable
SPEEDTEST = 0
CLOUDSAFE = 1
ANTISSATTACK = 0
AUTOEXEC = 0

MU_SUFFIX = 'microsoft.com'
MU_REGEX = '%4m.%suffix'

SERVER_PUB_ADDR = '127.0.0.1'  # mujson_mgr need this to generate ssr link
API_INTERFACE = 'modwebapi'  # glzjinmod, modwebapi

WEBAPI_URL = 'https://api.soulout.club'
WEBAPI_TOKEN = 'souloutclub'

# mudb
MUDB_FILE = 'mudb.json'

# Mysql
MYSQL_HOST = '3306.soulout.club'
MYSQL_PORT = 3306
MYSQL_USER = 'souloutclub@souloutclub'
MYSQL_PASS = 'souloutclub'
MYSQL_DB = 'panel'

MYSQL_SSL_ENABLE = 0
MYSQL_SSL_CA = ''
MYSQL_SSL_CERT = ''
MYSQL_SSL_KEY = ''

# API
API_HOST = '127.0.0.1'
API_PORT = 80
API_PATH = '/mu/v2/'
API_TOKEN = 'abcdef'
API_UPDATE_TIME = 60

# Manager (ignore this)
MANAGE_PASS = 'ss233333333'
# if you want manage in other server you should set this value to global ip
MANAGE_BIND_IP = '127.0.0.1'
# make sure this port is idle
MANAGE_PORT = 5000

# edit this file and server will auto reload

# boolean, enable to print mysql query
PRINT_MYSQL_QUERY = False

# second
MYSQL_PUSH_DURATION = 60

"""
get port offset by node->name
HK 1 #9900
then offset is 9900
"""
GET_PORT_OFFSET_BY_NODE_NAME = False
