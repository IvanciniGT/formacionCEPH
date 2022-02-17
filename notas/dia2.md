# Instalación del cluster CEPH

Cluster 6 maquinas
Subclusters procesos

Se hace en un único nodo -> 
    par de claves ssh. -> Llevamos a cada host

## Servicios básicos de ceph (mínimo)
    Bootstrap cluster - Instalación maquina 1. Esta no tiene ni siquiera por que ser una maquina MAESTRA.
    +mgr1 (TIPO DE SERVICIO: MANAGER).          Recopilar estadísticas de otros servicios
    +mon1 (TIPO DE SERVICIO: MONITORIZACION).   Recopilar estadísticas de otros servicios
        2n+1 (5 en práctica mínimo).            Los monitorizadores tengán su propia máquina
    +prometheus                                 Almacenando estadisticas de monitorización
        +grafana
    +alertmanager
    +crash
    
## PostInstalación
    + hosts
        Registrar la máquina y verificar que el nodo central tiene acceso vía ssh al host
    + servicios
        +mon
        +mgr

## OSD
    Añadir duscos duros a las maquinas

-------
Ceph ya. tendrá montado su sistema de almacenamiento completa
-------
Conexiones de Clientes
Servicios que podremos configurar en CEPH:
    - FS -> NFS
    - Block
    - Objetos. 

-------
CEPH es mucho espacio donde poder guardar cosas...
    MUCHOS POOL ... Con configuraciones diferentes
        3 Replicas ? Y de todos los objetos que guarde en ceph... quiero el mismo número de replicas? NO
            Hay datos muy críticos: 3,4 copias... 2 copias                €€€€€€€
        96 Particionado - Se guardarán sobre los 3 HDD - OSD.
        PLACEMENT GROUPS

----

Un dato que se guarda en CEPH .... no se guarda en un VOLUMEN UNICO... (depende)
Fichero 1Kb -> VOLUMEN HDD - OSD-7
Fichero 5 Mb -> No va a un único volumen. Particiones=Trozos de fichero. Lo guarda a trozos (4MiB)
    4Mb -> disco 1 - OSD
    1Mb -> disco 2 (de otra maquina) - OSD
            Cada trozo lo quiero en una partición. Que me aporta esto?              Seguridad X
                                                                        Velocidad Rendimiento
            Varios sitios de donde leer y escribir simultaneamente
    
    RAID 0


## Kibibytes...

KiB. kibibyte. De toda la vida era un Mb.  1024 b
MiB                                        1024 kb
GiB Gibibyte. De toda la vida era un Gb
Tib

Hoy en dia 1 Mb = 1000b



5 monitorizadores                               Contenedor1     Contenedor2     Contenedor3             <   Balanceo
2 servicios que atiendan peticiones NFS
3 servicios que atiendan peticiones Objetos

## Memoria RAM
Tener un sitio donde poner datos no persistentes    < Depende de la carga
Acceder rápido a datos                              < CACHE ( no depende de la carga de trabajo )
    BBDD
    OSD
    
En un contenedor puedo limitar el acceso a RAM: 16 Gbs .... ese contenedor X... y por ende los procesos que ahí corren
    solo pueden acceder a 8Gbs. < Que si un proceso llega a ese límite, en auto. docker, podman, kubernetes.
                                  Lo matan
                                  


                    8 Barreño
POOL  2 Replicas: 4 Particiones (PG) (2^n) < [n dato que se usa en el algoritmo de crush]

    OSD1 - PG1(T1)           PG3
    OSD2 -       PG2(T2)                 PG4
    OSD3 - PG1(T1)           PG3
    OSD4 -       PG2(T2)                 PG4
    OSD5 -
    OSD6 -


    OSD1 - PG1
    OSD2 - PG1
           PG1???

    
Objeto 8 Mb-> 2 tozos T1 T2 -> Algoritmo de CRUSH (en base al key del objeto hash) (OSD1, OSD2, OSD3, OSD4)
Alguien quiere recuperarlo (CLIENTE) ALGORITMO CRUSH (MAPA CRUSH < MON)
    -> OSD1, OSD2, OSD3, OSD4 él lo va adeterminar... no tiene que preguntar a nadie
Fichero -> 2 trozos ()



RED Normal:    1Gbit - 100Mbs - HHD (150)
RED Backend:   10 Gbit -1000Mbs




Inrea vuestra:
###########

Maquina 1
    Interfaz Publica \                              192.168.0.1
    Interfaz Bend    - NIC 1 | NIC 2                172.30.0.1. OSD.   --cluster-network
    Interfaz Adm     /                              172.80.0.1
Maquina 2
    Interfaz Publica \                              192.168.0.2
    Interfaz Privada - NIC 1 | NIC 2                172.30.0.2
    Interfaz Adm     /                              172.80.0.2
Maquina 3
    Interfaz Publica \                              192.168.0.3
    Interfaz Privada - NIC 1 | NIC 2                172.30.0.3
    Interfaz Adm     /                              172.80.0.3

firewalld
