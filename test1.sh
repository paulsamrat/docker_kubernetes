#!/bin/sh
a=10
b=20

if [ $a == $b ]
then
   echo "a is equal to b"
else
   echo "a is not equal to b"
fi
set -x
    #source /root/grid.configuration.properties
    #eval $(cat /root/grid.configuration.properties)
    #echo $master1.domain.ip
    #eval $(grep "^master1.domain.ip=" /root/grid.configuration.properties)
    #file="/root/grid.configuration.properties"
    #while IFS= read -r line
    #do        # display $line or do somthing with $line        #echo "$line"
    #done <"$file"
    master_domain_ip=$(grep master.domain.ip $"/mnt/grid-data/grid.configuration.properties" | awk -F= '{print $2}')
    master_domain_port=$(grep master.domain.port $"/mnt/grid-data/grid.configuration.properties" | awk -F= '{print $2}')
    master_domain_ac_username=$(grep master.domain.ac.username $"/mnt/grid-secret/grid.secret.properties" | awk -F= '{print $2}')
    master_domain_ac_password=$(grep master.domain.ac.password $"/mnt/grid-secret/grid.secret.properties" | awk -F= '{print $2}')
    worker_node_name=$(grep worker.node.name $"/etc/app/conf/set.conf" | awk -F= '{print $2}')
    dis_service_name=$(grep dis.service.name $"/etc/app/conf/set.conf" | awk -F= '{print $2}')
    worker_node_restart_count=worker_node_name=$(grep worker.node.restartCount $"/etc/app/conf/set.conf" | awk -F= '{print $2}')
    domain_name=dis_inmasterdmn01.informatica.com_1040_284
    SET_INDEX=${HOSTNAME##*-}
    echo $SET_INDEX
    echo $master_domain_ip
    echo $master_domain_port
    echo $master_domain_ac_username
    echo $master_domain_ac_password
    echo $worker_node_name
    #dis_service_name=dis01
if [ "$SET_INDEX" = "0" ]; then
(cd /usr/local/isp/bin && ./infacmd.sh createGrid -dn $domain_name -un $master_domain_ac_username -pd $master_domain_ac_password -gn k8s_grid
else
echo "not a valid choice"
fi
(cd /usr/local/isp/bin && ./infasetup.sh defineWorkerNode -dn $domain_name -nn $worker_node_name -na 10.75.149.36:31100 -dg $master_domain_ip:$master_domain_port -un $master_domain_ac_username -pd $master_domain_ac_password -rf nodeoptions.xml)
(cd /usr/local/isp/bin && ./infacmd.sh updategatewayinfo -dn $domain_name -dg $master_domain_ip:$master_domain_port)

    #TODO: if else logic based on restart count - create service should not be called only first time a node is provisioned
    #(cd /usr/local/isp/bin && ./infacmd.sh dis createService -dn Domain -nn $worker_node_name -un $master_domain_ac_username  -pd $master_domain_ac_password  -HttpPort 8888 -sn $dis_service_name -rs mrs -rsun $master_domain_ac_username -rspd $master_domain_ac_password -rssdn "" -httpProtocolType http)
    #(cd /usr/local/tomcat/bin && ./infaservice.sh startup)

    #(cd /usr/local/isp/bin && ./infacmd.sh removeService -dn Domain -un Administrator -pd Administrator -sn dis01)
