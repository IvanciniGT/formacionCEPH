curl --silent --remote-name --location https://github.com/ceph/ceph/raw/pacific/src/cephadm/cephadm

chmod +x cephadm

sudo cephadm add-repo --release pacific

sudo ./cephadm install

                            # Red publica
#cephadm bootstrap --mon-ip=172.31.11.2
sudo cephadm bootstrap --mon-ip $(hostname -I | cut -d' ' -f1)

# Abrirnos un contenedor con la configuración de nuestro cluster para usar el cliente
 # ESTO NO ES PARTE DE LA INSTALACION... SOLO POR SI QUIERO EMPEZAR A ATACAR AL CLUSTER DESDE UN CLIENTE
sudo cephadm shell 

# Si yo no paso una clave publica y provada en el momento de la instalación, se me genera una... 
# La tengo que meter en el resto de maquinas
cat ceph.pub | sudo tee -a /root/.ssh/authorized_keys
# ssh-copy-id

# Dar de alta maquinas en el cluster. Añadir los hosts

ceph orch host add ip-172-31-11-154 172.31.11.154
ceph orch host add ip-172-31-1-135 172.31.1.135 
ceph orch host add ip-172-31-12-180 172.31.12.180
ceph orch host add ip-172-31-3-193 172.31.3.193
ceph orch host add ip-172-31-11-174 172.31.11.174

ceph orch host label add ip-172-31-11-154 _admin
ceph orch host label add ip-172-31-1-135 _admin
ceph orch host label add ip-172-31-12-180 _admin
ceph orch host label add ip-172-31-3-193 _admin
ceph orch host label add ip-172-31-11-174 _admin

ceph orch daemon add mon ip-172-31-11-154
ceph orch daemon add mon ip-172-31-1-135
ceph orch daemon add mon ip-172-31-12-180
ceph orch daemon add mon ip-172-31-11-154
ceph orch daemon add mon ip-172-31-3-193