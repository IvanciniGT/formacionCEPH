Casa acceda
                    |
proxy-reverso.  ha-proxy ---
                 | | |
Web server - apache. red privada


--------------------------------------------------

POOLS -> Replicación, Compresión, Quota

MDS -> Servicio FileSystem dentro de CEPH 
        Demonios
            FS          - Pool de metadatos
                        - Pool datos (ficheros)    

MOUNT FS
    Mount
    ceph-fuse
    
Ejemplo de como montar automaticamente un volumen en linux 
----- /etc/systemd/system/ceph.mount
[Unit]
Description=Prueba de montaje de ceph en cliente

[Mount]
Where=/ceph
What=172.31.11.2:6789,172.31.11.2:6789:/
Type=ceph
Options=name=ivan,secret=AQCNexZiHOYyEBAAqbzjKOvGSzMmdl29IMFo9A==,fs=ivan

[Install]
WantedBy=multi-user.target
----- /etc/systemd/system/ceph.automount
[Unit]
Description=Automontaje de montaje de ceph en cliente

[Mount]
Where=/ceph

[Install]
WantedBy=multi-user.target
----
Servicio controlado por stystemd (via systemctl):
systemctl start         - Arranca
systemctl stop          - Para
            restart
            status
          enabled       - Habilita para inicio automatico (entra en el siguiente reinicio)
          disabled      - deshabilita el inicio automtico

-----------------------------------------------------------------------------------------------
FileLayouts. se gestiona desde getfattr setfattr.      paquete attr
-----------------------------------------------------------------------------------------------
Esto controla cómo se guardan los archivos en el pool. 
En el pool que guardamos? objetos

Cada archivo / cada directorio va a tener unos atributos de ceph:
ceph.file.layout.           <<< DE UN FICHERO, solo se pueden cabiar datos, si está vacio.
ceph.dir.layout.
                stripe_unit=4194304
                stripe_count=1
                object_size=4194304
                pool=ivan               -- En qué pool se guarda este fichero/carpeta

Cada archivo o directorio creado, hereda los datos de la carpeta padre (OJO EN CREACION)
    POSTERIORES MODIFICACIONES NO SE HEREDAN

/
    carpeta1/   
             carpeta2/
             carpeta3/
        
Dia 1: carpeta1: stripe_count=1
Dia 1: creo carpeta 2
Dia 1: carpeta2: stripe_count=1

Dia 2: carpeta1: stripe_count=2 >>> Lo cambio
Dia 2: carpeta2: stripe_count=1 <<< Este sigue igual
Dia 2: creo carpeta 3
Dia 2: carpeta2: stripe_count=2

/
    programas/      Distinto factor de replicacion- sin compresion
    datos/                      3           - sin compresion
    backups/                    3           factor compresion alto
    backupsanteriores/          2           factor compresion alto


Los veis por defecto
-------------------- 4 Mbs
stripe_unit=4194304             
stripe_count=1          < Con esta configuracion no hay RAID0
object_size=4194304 < Siempre tiene que ser multiplo del stripe-unit

Un archivo se guarda en colecciones de objetos
Una coleccion de objetos tiene "stripe_count" objetos
Cada objeto tendrá de tamaño: "object_size" bytes (menos el último... que será más chico normalmente)
Que contiene cada objeto....
    Una coleccion de objetos guarda un trozo secuencial (continuos) del fichero
    Cada objeto contien varios trozos del fichero (que no tienen por que ser continuos), 
        de tamaño stripe_unit

VARIANTE RAID0
---------------------------------------------------------------------------------------------------------
El ejemplo lo hago con caracteres... llevarlo a bytes (seria equivalente)
FICHERO: abc def ghi jkl mnñ opq rst uvw | xyz 012 345 678 9
            COLECCION 1 de objetos       |  COLECCION 2 de objetos
stripe_unit=3             -- Tamaño en el que voy a partir el fichero
stripe_count=2            -- Cuantos objetos por coleccion
object_size=12            -- Tamaño del objeto 

------
Coleccion de objetos 1: Cada objeto en un PG
Objeto 1                    Objeto 2  PG1 P1' P1''              
abc                         def
ghi                         jkl
mnñ                         opq
rst                         uvw
-------
Coleccion de objetos 2: Cada objeto en un PG
Objeto 3                    Objeto 4                
xyz                         012
345                         678
9



EJEMPLO 2: fichero1.txt
FICHERO: abc def ghi jkl mnñ opq rst uvw | xyz 012 345 678 9
            COLECCION 1 de objetos       |  COLECCION 2 de objetos
stripe_unit=3             -- Tamaño en el que voy a partir el fichero
stripe_count=1            -- Cuantos objetos por coleccion
object_size=12            -- Tamaño del objeto 
    
PG= 8: 2^3: n=3
                                             NOMBRE OBJETO   HASH NOMBRE DEL OBJETO ... Me quedo con n=3 ultimos bits
Set Objectos 1: Objeto 1:  abc def ghi jkl < fichero1.txt-1 > 1010001010101.010         PG 2
Set Objectos 2: Objeto 2:  mnñ opq rst uvw < fichero1.txt-2 > 1010001001011.010         PG 2
Set Objectos 3: Objeto 3:  xyz 012 345 678 < fichero1.txt-3 > 1010001011100.010         PG 2
Set Objectos 4: Objeto 4:  9               < fichero1.txt-4 > 1010001011100.101         PG 5


-----------------------------------------------------------------------------------------------
Crush map


-----------------------------------------------------------------------------------------------
NOMBRE FICHERO CEPHFS-> objetos... con sus nombres.

Algoritmo de CRUSH
PG: 2 elevando a n Placemnt Groups
Nombre-Objeto: 192831-191238731-1203814-12398614 RADOS
                HASH        0100011101010010101010100101010011111010101010 Ultimos n bits-> a que PG va
            4 placementgroups:
                    00   - PG0
                    01   - PG1
                    10   - PG2
                    11   - PG4

$ ceph osd tree
VISTA DEL CRUSH MAP

 -1         1.66937  root default                                        
 -7         0.28793      host ip-172-31-1-135                            
  2    ssd  0.01459          osd.2                  up   1.00000  1.00000
 14    ssd  0.01459          osd.14                 up   1.00000  1.00000
 16    ssd  0.01459          osd.16                 up   1.00000  1.00000
 18    ssd  0.12209          osd.18                 up   1.00000  1.00000
 20    ssd  0.12209          osd.20                 up   1.00000  1.00000
-13         0.27338      host ip-172-31-11-154                           
  5    ssd  0.01459          osd.5                  up   1.00000  1.00000
 10    ssd  0.12939          osd.10                 up   1.00000  1.00000
 11    ssd  0.12939          osd.11                 up   1.00000  1.00000
 -3         0.27338      host ip-172-31-11-174                           
  0    ssd  0.01459          osd.0                  up   1.00000  1.00000
  8    ssd  0.12939          osd.8                  up   1.00000  1.00000
  9    ssd  0.12939          osd.9                  up   1.00000  1.00000
 -5         0.27338      host ip-172-31-11-2                             
  1    ssd  0.01459          osd.1                  up   1.00000  1.00000
 12    ssd  0.12939          osd.12                 up   1.00000  1.00000
 13    ssd  0.12939          osd.13                 up   1.00000  1.00000
-11         0.28793      host ip-172-31-12-180                           
  4    ssd  0.01459          osd.4                  up   1.00000  1.00000
 15    ssd  0.01459          osd.15                 up   1.00000  1.00000
 17    ssd  0.01459          osd.17                 up   1.00000  1.00000
 19    ssd  0.12209          osd.19                 up   1.00000  1.00000
 21    ssd  0.12209          osd.21                 up   1.00000  1.00000
 -9         0.27338      host ip-172-31-3-193                            
  3    ssd  0.01459          osd.3                  up   1.00000  1.00000
  6    ssd  0.12939          osd.6                  up   1.00000  1.00000
  7    ssd  0.12939          osd.7                  up   1.00000  1.00000

-----
root default
    datacenter
        sala
            pasillo
                rack
                    chasis. Como se vaya el chasis... 
                         host ip-172-31-1-135               Y si se joda la fuente de alimentacion de la maquina?
                             osd.2                          PG0(A).  HDD se jode... sigo funcionando?
                             osd.14                         
                             osd.16                         
                             osd.18                
                             osd.20                         
                         host ip-172-31-11-154     
                             osd.5                          
                             osd.10                
                             osd.11                
                         host ip-172-31-11-174     
                             osd.0                          PG0(C)
                             osd.8                 
                             osd.9                 
     host ip-172-31-11-2       
         osd.1                 
         osd.12                
         osd.13                
     host ip-172-31-12-180     
         osd.4                                              PG0(B)
         osd.15                
         osd.17                
         osd.19                
         osd.21                
     host ip-172-31-3-193      
         osd.3                 
         osd.6                 
         osd.7                 

POOLA-> 4 PG... con replicas 3 -> 4x3=12 instancias de PG 4 PG.. pero grabados un total de 12 veces
PGA(1)


MEGAMAQUINA:
    32 MVMe
    
TIPO: root> datacenter> room> row> pod> pdu> rach> chassis> host

ceph osd crush add-bucket NOMBRE TIPO
ceph osd crush remove
ceph osd crush move

ceph osd crush add-bucket dc-ivan datacenter
ceph osd crush move ip-172-31-11-2 datacenter=dc-ivan


ceph osd crush add-bucket dc-ivan datacenter
ceph osd crush add-bucket sala1 room
ceph osd crush move sala1 datacenter=dc-ivan
ceph osd crush add-bucket rack1 rack
ceph osd crush move rack1 datacenter=dc-ivan room=sala1
ceph osd crush move ip-172-31-11-2 datacenter=dc-ivan room=sala1 rack=rack1 

ceph osd crush rm-device-class osd.12
ceph osd crush set-device-class ssd osd.12
                                hdd
                                nvme
                                
ceph osd crush set osd.12 WEIGHT --RARO... Esto tiene que ver con la cantidad de PGs que se van a asignar a este OSD... en función del tamaño de discos disponible