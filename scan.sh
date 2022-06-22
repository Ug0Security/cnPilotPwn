cat iplist | while read line
do
echo $line
bash atk.sh $line $1
echo ""
echo ""
done
