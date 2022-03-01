MDS
    -   Ficheros? Pools que configure
    -   Metadatos? donde se guardan?  pool ... en el que configure.. si no le digo ninguno... en el mismo que los ficheros


    
                    POOLS
                metadatos  ficheros
$ceph fs new ivan prueba1 ivan



FileLayout: Como se controla ell cómo se guardan los archivos dentro de RADOS
    paquete attr
    getfattr
    setfattr
    
                 FILE_SYSTEM.  USUARIO: De la forma client.XXXXX    RUTA    PERMISOS
$ ceph fs authorize ivan        client.ivan                           /         rw


$ ceph fs authorize alvaro client.alvaro  /   rw > /home/ubuntu/environment/curso/claves/ceph.client.alvaro.keyring

ceph fs authorize leyre client.leyre  /   rw > /home/ubuntu/environment/curso/claves/ceph.client.leyre.keyring

Existe el permiso "p" en los filesystems.... con este permiso pueden tocar el FileLayout

Montar el volumen en una máquina Linux:
- Kernel linux
- ceph-fuse


ceph-fuse
    -n client.XXXX
    --id XXXX
    -k Fichero keyring
    --client_fs             ivan
    
    -c Fichero conf ceph
    -m MONITOR
    
    -f foreground
    -d background
               USUARIO                                                                        FS
ceph-fuse --id ivan -k /etc/ceph/ceph.client.ivan.keyring -c /etc/ceph/ceph.conf --client_fs ivan /mnt/ivanceph

ceph-fuse --id leyre -k /etc/ceph/ceph.client.leyre.keyring -c /etc/ceph/ceph.conf --client_fs leyre /mnt/leyreceph

mount -t ceph
mount.ceph     172.31.11.2:6789:/ /mnt/ivan2ceph -o name=ivan,secret=AQCNexZiHOYyEBAAqbzjKOvGSzMmdl29IMFo9A==