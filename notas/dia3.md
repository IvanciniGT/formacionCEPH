Cluster Ceph se distribuye en bastantes máquinas.

CEPH es un sistema distribuido.
CEPH es un sistema que tiene distintas funcionalidades. Cada una de ellas llevada a cabo por un proceso independiente que 
puede ejecutarse en el mismo host o no.

SERVICIOS: Los ofrecen cada una de esas "funcionaldiades" de las que hablábamos:
- mon: Monitorización
- mgr: Manager
- osd: Almacenamiento
- mds: Metadatos de un sistema de archivos FS
- iSCSI
- NFS

Los servicios son llevados a cabo por procesos (DEMONIOS). Cuántos? Depende
Todos estos DEMONIOS corren en contenedores dentro de CEPH
- mgr: Al menos 1... al menos 2 en la práctica por HA...opcionalmente otros más en otras máquinas... que quedan en reserva (activo/pasivo)
- mon: Al menos 1... al menos 3 (2n+1) en la práctica por HA.

# Nos va dar los servicios que tengo en el cluster
$ ceph orch ls
                --service_type 
                --host

# Nos va dar los demonios que tengo en el cluster
$ ceph orch ps
                --daemon_type
                
ceph orch daemon add mon ip-172-31-11-154

# Exportar la configuración de los servicios:
$ ceph orch ls --export

# Para dar de alta y configurar servicios:
$ ceph orch apply -i FICHERO

# Dispositivos de almacenamiento en mis maquinas del cluster
$ ceph orch device ls
# Crea osds para todos los dispositovs de almacenamiento disponibles 
$ ceph orch apply osd --all-available-devices
$ ceph orch daemon add osd ip-172-31-11-2:/dev/nvme1n1


Los monitorizadores me interesa que su gestión la lleve CEPH:
- Oye, quiero 5 monitorizadores (o 7) en las máquinas que tengan la etiqueta "monitorizador"  <<<<< Monitorizador.   < BC Apunte a todas...
- Manager, quiero 2 manager en las máquinas que tengan la etiqueta "manager" 
- OSD ???? 


-----------------------------------------------------------------
                    Cliente
                        mibbdd.db 2 replicas pero lo guardo entero
                        consultas.txt(parte1, parte2) REPLICAS: 2
    Objetos             Ficheros - MetaDataService              BLOQUES
                            mds                                 iscsi      < Estos gestionan el nivel de particionado que quiero de cada dato que entra
                                                                              En cuantos objetos se van a convertir (trozos)


    
    RADOS: Reliable Autonomic Distributed Object Storage
    
    Placement Groups: Habitaciones
    
    
OSD.  OSD              OSD     OSD                             ¿Qué guardan? Objetos. CADA OSD Básicamente gestiona una BBDD clave-valor
 |     |                |       |
HDD1 SDD2             HDD3     HDD4 < Formato propio de CEPH
--------------------------------
P1    P1'              P2      P2'         PROBLEMA?  Mucho mayor riesgo de perder información
A                       A'
 
Cuantas combinaciones de 2 discos (2 replicas) puedo hacer? 4x3: 12/2= 6
                A       P
HDD1    SDD2            ******
HDD1    HDD3 *****
HDD1    HDD4
SDD2    HDD3
SSD2    HDD4
HDD3    HDD4            ******

Probabilidad condicionada: En caso de joderse 2 discos duros... que probabilidad hay de que sean los mios (donde tengo los datos)
    Del fichero A: 1/6: 17% de probabilidad de perder datos.
    Del fichero P: 2/6: 34% de probabilidad de perder datos.


Si guardo un archivo... ese archivo se guarda como un único objeto o en varios objetos (partido en trozos)?
La replicación es otro concepto: CADA OBJETO QUE TENGO QUE GUARDAR EN RADOS... cuantas copias quiero de él? H/A ... escalabilidad




4 sitios donde guardar los objetos
HDD1 - OSD1
HDD2 - OSD2
HDD3 - OSD3
HDD4 - OSD4


hola.txt -> CRUSH

Algoritmo de huella? hash ? MD5 ... Huella... firma única de un objeto. Un mismo objeto siempre deja la misma huella.
                                                                        Desde la huella no puedo regerar el objeto

Si tuviera 23 habitaciones donde alojar personas.
Listado central donde digo cada persona donde debe ir... Problemón... Imaginaos tadas las personas mirando la lista en la puerta.. CUELLO DE BOTELLA
Calcula la letra de tu DNI: Habitacion 1
                            Habitacion...23
