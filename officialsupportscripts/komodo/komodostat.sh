count=$(/opt/komodo/komodo.sh getconnectioncount)
case $count in
    ''|*[!0-9]*) dstat=0 ;;
    *) dstat=1 ;;
esac
if [ "$dstat" == "0" ]; then
	/opt/komodo/start.sh
fi
