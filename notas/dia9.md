## NFS

Configurar un servicio de NFS.. con sus demonios en las máquinas correspondientes
Export de NFS

$ ceph nfs cluster create SERVICIO "UBICACION DEMONIOS" ?????

$ ceph nfs cluster create ivannfs "2 label:ivan" 

$ ceph nfs export create cephfs --cluster-id ivannfs --pseudo-path /exportado --fsname ivan

$ ceph nfs export ls ivannfs

$ ceph nfs export rm ivannfs /exportado

$ ceph nfs export info ivannfs /exportado


Cluster:
Maquina 1 : Ivan
    demonio1(c) - IP1
Maquina 2 : Ivan
    demonio2(c) - IP2 - PUFFF
Maquina 3 : Ivan
    demonio3(c) - IP3 

Balanceo de carga: HAProxy [IP1, IP3]

Cluster NFS: 2 Demonios -> label:Ivan

NFS: IP1
     IP2

----------

# SNAPSHOTS:

## Hacer snapshots de un pool completo              * OLVIDADO
$ ceph osd pool mksnap POOL NOMBRE_SNAPSHOT
$ ceph osd pool rmsnap POOL NOMBRE_SNAPSHOT
$ rados -p POOL lssnap
$ rados -p POOL rollback NOMBRE_SNAPSHOT

Son snapshots Sincronos.

CONSISTENCIA DE DATOS ! Si lo hago en frio guay... en caliente, no se me asegura consistencia de la información

## Hacer snapshots de un Filesystem CEPHFS          * ESTE !!!! GUAY !!!!

SI SON CONSISTENTES. Son asíncronos.

Por defecto en un FS no podemos hacer snapshots... hay que activarlo

$ ceph fs set FILE-SYSTEM allow_new_snaps true

$ ceph fs set ivan allow_new_snaps true
    # Aqui podría haber creado snapshots.... los que quisiera
$ ceph fs set ivan allow_new_snaps false
    # Aqui ya no podría crear nuevos..  pero conservo los que tengo hasta ahora






----- Configuración de un FS que trabaje con varios pools

MDS - 2 demonios
Filesystem X
    Tendrá asociados varios pools... 1 de metadatos... y muchos de datos.
    Pool METADATOS
/
/carpeta1
    DIR_LAYOUT attr
        Stripping 
        PoolA
/carpeta2
    DIR_LAYOUT
        Stripping 
        PoolB
/carpeta3
    DIR_LAYOUT
        Stripping 
        PoolC

NFS - 2 demonios
    exports:
        /carpeta1   -> Filesystem X /carpeta1
        /carpeta2   -> Filesystem X /carpeta2
        /carpeta3   -> Filesystem X /carpeta3
        


Snapshots:
    S1 Pool METADATOS ******
    S1 Pool A
    S1 Pool B
    S1 Pool C
    
    Upss... hay que ir para atrás... que en la carpeta A... la hemos regao...
    
---
# Tamaño del snapshot:
https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/BKVP6HC7HIP5GWUGUM6SNOVVU5WGFSXZ/

Antes de hacer el spanshot: /datos
$ getfattr --only-values --absolute-names -d -m ceph.dir.rbytes /datos
1Tb

Haces el snapshot
Despues del snapshot... La diferencia es el tamaño del snapshot.
$ getfattr --only-values --absolute-names -d -m ceph.dir.rbytes /datos
1.5 Tbs

-----
Cliente de filesystem de ceph:

Instalar el paquete cephfs-shell

Crear archivo de configuración: ~/.cephfs-shell

    [cephfs-shell]
    prompt = CephFS:~/>>>
    continuation_prompt = >
    quiet = False
    timing = False
    colors = True
    debug = False
    abbrev = False
    autorun_on_edit = False
    echo = False
    editor = vim
    feedback_to_output = False
    locals_in_py = True
    
Usa para conectarse "por defecto" el usuario admin, con keyring en /etc/ceph


# CEPH

Backend Openstack                           <<<<<<
    Montar un cloud privado: AWS
        Cinder -> CEPH
        Manila -> CEPH
        Neutron
        Compute
        
Backend Kubernetes - Rock

CrushMap - OSDs
    datacenters
        Rooms
            ...
                Racks
                    ...
                        Hosts
                        
Quiero tener en cada datacenter 3 mon


# Mirroring: 
# https://docs.ceph.com/en/pacific/cephfs/cephfs-mirroring/

Llevar snapshots a un(os) cluster(s) remotos:
-En el cluster de partida un usuario para iniciar el mirroring
-En el cluster de destino igual.. otro usuario

A nivel del cluster local:
-Activar el modulo de mirroring
-Tener un demonio de mirroring
-Configurar cluster remotos, con su usuario
-Dar de alta los filesystems de los que queremos que se esté haciendo el mirroring.

/
    data/
         .snap/
                ultimo                                                          
                snap-1
                snap-2
                snap-3
-----

Openstack - cloud < REDHAT
- Proveer infraestructura al cliente, que él configura y usa.

Kubernetes ~ Linux KERNEL
           ~K3S
           K8S
           Vanilla
           Openshift    < REDHAT
- Proveer infraestructura... pero de forma invisible al cliente.
NAMESPACE - QUOTA (CPUs, ALMAC. RAM)
    Despliegues de aplicaciones


Cluster Kubernetes:
    Tenemos volumenes de 3 tipos:
        rapidos
        lentos
        más tolerancia a fallos
    Maquinas1
        mon
    Maquinas2
        mgr... 
    Maquinas3
        osd
    Maquinas4
        osds
    Maquinas5
        CPU y RAM
        sqlserver
        oracle
        weblogic
    Maquinas6
        CPU y RAM
    Maquinas7
        CPU y RAM

Despliegue de una app > Contenedores
                            Filesystem
                                Montar un volumen de almacenamiento > Para un uso muy concreto APP1/ APP2
    
                     ROCK
PersistentVolumeClaim <> PersistentVolume (CEPH) 

Kubernetes NFS:
    - Rook
        NFS
        CEPH
            Rook lo gestione dentro del cluster: Demonios de CEPH corren dentro del cluster
            Se externo
    - nfs-subdir-external-provisioner
    
Orquestador de los demonios de CEPH
    Kubernetes 1 cluster único: dentro tienes máquinas de computo y de almacenamiento
    cephadm    1 cluster solo para ceph
    

Kubernetes
    Rook    <>  Cluster CEPH   <>    Otros clientes
    
    
Kubernetes se configura (instalamos cosas en él) a través de ficheros YAML... Tienen su complejidad
    HELM < CHARTS (plantillas de despliegue de una app rook)
           El chart está parametrizado. Parametrización se hace también en ficheros YAML... pero de más alto nivel. más sencillos
    OPERADOR se configura también desde un fichero YAML
    
    
    
    helm pull rook-master/rook --version v0.6.0-156.gef983d6