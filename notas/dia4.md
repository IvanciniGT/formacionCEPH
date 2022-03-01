OSD - Devices
Pools
PG


CEPH - OSD - Demonio (contenedor)
Volumenes - Dispositivos físicos donde almacenar datos: HDD, SSD, NVME

1 OSD - 1 Dispositivo

Los volumenes se gestionan mediante un Sistema de almacenamiento propio de ceph

Base de datos
    Datos           -       data
    Metadatos       -       db
    Journal log     -       wal

Los volumenes por defecto guardan los 3 tipos de infomación.
En según qué escenarios me puede interesar dedicar volumenes a solo 1 tipo de información:
    El más rápido de todos lo dedicaré al wal. Esto es importante cuando el volumen donde voy a guardar datos es lento.
    El siguiente más rápido lo dedicaré a metadatos: db
    El más lento a datos.


    
                      Clientes                  Pool:   POOL1
          -----------------------------         Objeto: A
          |               |           |         PG:     PG1 ?? Algoritmo CRUSH
          v               v           v
        CephFS          Block       Object                  fichero 17-> 5 trozos (5 objetos)
         /               RADOS          \
        /                                \
     POOL1  ------                      POOL2    
     |  |  \     |
    PG1 PG2 PG3 PG4                    
     
---------------------------------------------------------
    OSD1        OSD2            OSD3            OSD4
---------------------------------------------------------
    PG1         PG2             PG3             PG4             Me mejoran rendimiento
    PG4'        PG3'            PG2'            PG1'
---------------------------------------------------------
      |          |                |              |
   Devices.   Devices           Devices.      Devices
    
¿Cuantos placement groups me interesa tener?    
En este ejemplo... a priori con 4 voy que me mato... siempre y cuando:
- El algoritmo de crush esté repartiendo los datos equilibradamente         ESTO NO LO PUEDO GARANTIZAR
- Todos los objetos que yo guarde sean del mismo tamaño                     ESTO TAMPOCO LO PUEDO GARANTIZAR

La regla básica en CEPH es nº placement groups>= OSD x 100 / replicas Tiene que ser potencia de 2
    6x100/3 = 200....256

Pool: Agrupación lógica de objetos con un determinado algoritmo de replicación
        2 Tipos: replicacion < Por defecto                  RAID 1 espejo   1 objeto se guarda en un único PG
                    cuantas replicas (size)
                 erasure        No es por defecto           RAID 5
                    cuantro trozos hacemos y cuantos bloques de paridad almacenamos < Cuantos volumenes admito que se caigan sin perder datos

RAID 0: stripping           (2 volumenes  -> los convierto en 1, conservando tamaño.. puedo escribir ellos simultaneamente)
                                Cada volumen 1Tb. -> Volumen 2Tbs           Mejora rendimiento
RAID 1: espejo              (2volumenes. -> los convierto en 1... pero pediendo la mitad del tamaño total) Guardando datos duplicados
                                Cada volumen 1Tb. -> Volumen 1Tbs           Seguridad + rendimiento en lectura
RAID10: lo mejor de los 2 mundos 4 discos
    2 discos en RAID 0 y RAID 1 con otros 2: Todos los datos bien protegidos (2 copias)... Mejora rendimiento varios discos donde guardar/leer info
                                Sigo perdiendo espacio sobre el total. Tengo 4 discos 1Tb... me quedo con 2Tbs.

RAID 5: Partiendo cada fichero que quiero meter en trozos... que se distribuyen entre varios discos:
                                Tengo replicación de datos y muchos sitios de donde leer/escribir.
                                Mejora el aprovechamiento del espacio





En cada máquina:
2-HDD           15Gb
    data
2-SSD           10Gb
    SSD wal
    SSD db
    
Cuántos OSD?

---  Esto va a dar lugar a un conjunto de demonios: Contenedores
service_type:   osd
service_id:     ivan_osd
placement:
    label:  ivan
spec:
    all: true
    data_devices:
        paths:
            - /dev/sdg
        # vendor:
        # model:
        rotational: 1 # HDD
        size: 5Gb           # Un tamaño exacto
        size: ":5Gb"        #  Hasta 5Gbs
        size: "5Gb:"        #  A partir de 5Gbs
        size: "5Gb:10Gb"
    db_devices:
        rotational: 0 # SSD MVNE
        limit: 1
    wal_devices:
        rotational: 0 # SSD MVNE
        limit: 1
    osds_per_device:
    wal_slots:
    db_slots:
    
ceph orch host label add ip-172-31-11-2 ivan
ceph orch apply -i FICHERO.yaml --dry-run
    --dry-run. Simulación de crear aquello
    
POOL: ivan
      replicated
      autoscale:
          WARN
          OFF
          ON
      compression: none


---      

OSD17 - datos: HDD1
      - db:    SDD1
      - wal:   NVME1

20 discos HDD   
6 discos SDD. 
2 NVME              No tiene OSD
Raid espejo
    Cada nvme se usa por 20 osd 

Cuantos OSD generaremos al final? 20 OSDs en total
Si se jode un HDD, que pierdo? 1 OSD... con sus pg
Si se jode un MVNE, que pierdo? 10 OSD... con sus pg


El numero de OSDs total será el del número de devices
A no ser que quiera más de un OSD por device (NVME)


El servicio de almacenamiento es un OSD
    De cada objeto que guarde un OSD, se ha de guardar distinto tipo de información
        - objeto                HDD         1 disco fisico
        - metadatos: db         ssd         1 disco fisico
        - registros: Wal        NVME        1 disco fisico

20 discos HDD   
6 discos SDD. < espejo
20 hdd data
3 db y wall

data_devices:
    rotational: 1
db_devices:
    rotational: 0 # Solo poniendo esto, ya el wal iría aquí
    
---

$ ceph osd pool create NOMBRE_POOL PG replicated --autoscale-mode=on|off|warn
                                    erasure
                                    
$ ceph osd pool create ivan 256 replicated --autoscale-mode=warn

Las operaciones de splitting de Placement groups son muy pesadas                 

---
$ ceph osd pool set-quota ivan max_objects 100000 max_bytes 102400000
$ ceph osd pool set-quota ivan max_bytes 1000000
                                    ?
                                    Muy complejo de gestionar 

$ ceph osd pool delete ivan

mon_allow_pool_delete

---

$ ceph osd pool stats ivan

---

$ ceph osd pool set ivan CLAVE VALOR

compresion
size     < Replicas
min_size < Replicas mínimas para que el pool se mantenga activo



ceph osd pool set ivan size 4
ceph osd pool set ivan min_size 3





ceph orch ls --service_name=miguel_osd --export
