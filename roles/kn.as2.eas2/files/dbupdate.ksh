:
INTERACTIVE=FALSE
SERVER=""
DATABASE=""
USERNAME=""
PASSWORD=""

if [ $# = 0 ]
then
	echo "usage: $0 -i"
	echo "usage: $0 [-h <host>] -d <db> -u <user> -p <pwd>"
	echo "    <host> ....... the database host"
	echo "    <db> ......... name of the database to be updated"
	echo "    <user> ....... db user"
	echo "    <pwd> ........ this user's password"
	exit 1
fi

while [ $# -gt 0 ]
do
	if [ "$1" = "-i" ]
	then
		INTERACTIVE=TRUE
	fi
	if [ "$1" = "-s" ]
	then
		shift
		SERVER=$1
	fi
	if [ "$1" = "-d" ]
	then
		shift
		DATABASE=$1
	fi
	if [ "$1" = "-u" ]
	then
		shift
		USERNAME=$1
	fi
	if [ "$1" = "-p" ]
	then
		shift
		PASSWORD=$1
	fi
	shift
done

if [ "$INTERACTIVE" = "TRUE" ]
then
	echo "enter MySQL Server name or IP address (default: localhost):"
	read SERVER
	echo "enter DATABASE name:"
	read DATABASE
	echo "enter USERNAME:"
	read USERNAME
	echo "enter user's PASSWORD:"
	read PASSWORD
fi

if [ "$SERVER" = "" ]
then
    SERVER="localhost"
fi

if [ "$DATABASE" = "" ]
then
    echo "DATABASE name must not be empty"
    exit 1
fi

if [ "$USERNAME" = "" ]
then
    echo "USER name must not be empty"
    exit 1
fi

if [ "$PASSWORD" = "" ]
then
    echo "PASSWORD name must not be empty"
    exit 1
fi

VERSION=`mysql -h$SERVER -u$USERNAME -p$PASSWORD $DATABASE < detect_schema_version.sql | tail -1`
if [ "$VERSION" = "" ]
then
    echo "schema version could no be detected - terminating"
    exit 1
fi

GENERATION=`mysql -h$SERVER -u$USERNAME -p$PASSWORD $DATABASE < detect_schema_generation.sql | tail -1`
if [ "$GENERATION" = "" ]
then
    GENERATION=0
fi

echo "detected schema version $VERSION - generation $GENERATION"
echo "updating database schema - this may take a while - DO NOT INTERRUPT!"
if [ -f update_${VERSION}.sql ]
then
    echo update_${VERSION}.sql
    mysql -v -h$SERVER -u$USERNAME -p$PASSWORD $DATABASE < update_${VERSION}.sql
    if [ $? != 0 ]
    then
        echo "update failed"
        exit 1
    fi
fi
while true
do
    if [ -f incr_update_${GENERATION}.sql ]
    then
        echo incr_update_${GENERATION}.sql
        mysql -v -h$SERVER -u$USERNAME -p$PASSWORD $DATABASE < incr_update_${GENERATION}.sql
        if [ $? != 0 ]
        then
            echo "update failed"
            exit
        fi
        GENERATION=`expr $GENERATION + 1`
    else
        break
    fi
done
echo "update successful"

