function getHttpResult() {
    local code=$1
    if [ "$code" = "200" ] ||
       [ "$code" = "201" ]; then
        echo "SUCCESS"
    else
        echo "ERROR"
    fi
}


# check args
if  [ -z "$1" ] ||
    [ -z "$2" ] ||
    [ -z "$3" ] ||
    [ -z "$4" ]; then    
    echo "Usage: "    
    echo "./push_to_octopus.sh <OCTOPUS_ORG> <OCTOPUS_SPACE_NUMBER> <OCTOPUS_API_KEY> <PACKAGE_FILE_NAME>"
    exit 1
fi

OCTOPUS_ORG=$1
OCTOPUS_SPACE_FRAGMENT=$2
OCTOPUS_API_KEY=$3

PACKAGE_FILE_NAME=$4

http_code=$(curl -o out.html -w '%{http_code}'  -X POST https://${OCTOPUS_ORG}.octopus.app/api/${OCTOPUS_SPACE_FRAGMENT}/packages/raw -H "X-Octopus-ApiKey: ${OCTOPUS_API_KEY} " -F "data=@${PACKAGE_FILE_NAME}")
# -s --silent,  AVOID using this because it suppresses error messages
# -o --output, to file
# -w --write-out, malarkey 

http_result=$(getHttpResult $http_code)

if [ $http_result = "SUCCESS" ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo "HTTP status code '$http_code'"
echo ""
echo "RESPONSE START"
echo $(cat out.html)
echo ""
echo "RESPONSE END"


if [ $http_result = "SUCCESS" ]; then
    exit 0
fi

exit 1
