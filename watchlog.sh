while true; do
    kubectl get all | sed 's/.\[[0-9;]*m//g' > logs/watch.log
    sleep 2
done