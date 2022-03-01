# Pools erasure

Tipo de pool que ofrece cierta resistencia/fiabilidad a la perdida de datos, con un tamaño contenido, 
eso si... a costa de un uso MUY ALTO de CPU y RAM

El rendimiento en lectura es inferior a los replicados.

Además tienen menos funcionalidades que los pools replicados.

Casos de uso:
    - Almacenamiento en frio.... pocas lecturas


Pool de replicación:
    - Configuramos el numero de replicas: 3 replicas
        Puedo perder: Nº replicias -1 OSDs... que 2 osds se caigan
    
    Objeto que ocupa un tamaño X... cuanto espacio ocupa en el cluster de CEPH? 3·X
    
     700€ - 18 Tbs .... 18x3 = 48 Tbs de los que puedo usar 18Tb
    2100€ 
    
Pool erasure: ~ RAID5
    - Configuramos el numero de trozos en los que guardar el objeto: 2
    - Número adicional de trozos de reconstrucción del objeto:       1 ***** Cuantos trozos puedo perder...
            Como cada trozo se va a guardar en un OSD diferente (eso me lo asegura CEPH)
            Es en definitiva el número de OSDs que puedo perder
    
    Yo, partiendo de un objeto X:
        Guardo: T1 - La mitad de los bytes X por un lado
                T2 - La otra mitad de los bytes X por otro lado
                TR - Un trozo nuevo... generado a través de un algoritmo especial (erasure)
                    Este trozo tien información capaz de regererar desde cualquiera de los trozos anteriores el otro.
                    
                T1 + TR -> T2
                T2 + TR -> T1
    
    Cuantos trozos puedo perder en esta configuración?              1... el numero de trozos de reconstrucción
    
    - Configuramos el numero de trozos en los que guardar el objeto: 2
    - Número adicional de trozos de reconstrucción del objeto:       2 ***** Cuantos trozos puedo perder...
    
    Yo, partiendo de un objeto X:
        Guardo: T1 - La mitad de los bytes X por un lado
                T2 - La otra mitad de los bytes X por otro lado
                TR1 - Un trozo nuevo... generado a través de un algoritmo especial (erasure)
                    Este trozo tien información capaz de regererar desde cualquiera de los trozos anteriores el otro.
                TR2 - Un trozo nuevo... generado a través de un algoritmo especial (erasure)
                    Este trozo tien información capaz de regererar desde cualquiera de los trozos anteriores el otro.
    
    Cuanto me ocupa el objeto:
        Objeto de tamaño X... guardo 4 trozos: 
            Cada trozo de objeto es de tamaño X/2: 4·X/2= 2·X
            Acabo de ahorrar un tercio del almacenamiento. 
            
            
    - Configuramos el numero de trozos en los que guardar el objeto: 3
    - Número adicional de trozos de reconstrucción del objeto:       2 ***** Cuantos trozos puedo perder...
            
    
    Cada trozo ocupa X/3
    Cada objeto lo guardo en 5 trozos: 5*X/3 1,66·X
    
    Para hacer esa magia.... hace falta mucha CPU y RAM ... para calcular los trozos 

PROBLEMAS: 
    -   No puedo guardar OMAP dentro de estos pools -> Implicación -> 
        Los metadata de los MDS usan ese tipo de datos ... No puedo usar este tipo de pools para estos fines.
    
        Vamos a necesitar un pool rplicado para los metadatos de mds... los datos si que pueden ir en un pool erasure.
    
    -   Los pools erasure por defecto no admiten sobreescrituras de un objeto.
            Implica... es que apriori tampoco se pueden usar para un mds... ni para datos.
        
        Lo puedo activar EXPLICITAMENTE:
        $ ceph osd pool set MI-POOL-ERASURE allow_ec_overwrites true
        
        Esta opcion solo la puedo activar si los OSDs los tengo con FS propio de CEPH: BlueStore

------
Al trabajar con ficheros, al abrirlo para escribir en el tenemos 2 opciones:
- Acceso secuencial
    Me pongo y escribo en el fichero:
    - Al principio. Sobreescribo
    - Al final: Añado
- Acceso aleatorio
    Me permite poner la aguja del disco donde yo quiero (byte) y a partir de ahi escribir n bytes. <<<< BBDD



    
    
Al trabajar con un pool de tipo erasure, lo que le aplicamos es un profile-erasure:
    Numero de trozos
    Numero de trozos de reconstrucción
    Algoritmo
    
    Crush failure domain
    Crush root
    Crush device class
    
    Packetsize
        2048

En el ruleset que se generará asociado al profile, en lugar de poner la palabra firstn, se usa la palabra indep.
Eso tiene que ver con qué se hace en cado de rotura/perdida de un OSD


Al trabajar con Pools replicados... de cada PG, cuantas copias se hacían? Número de replicas -1...
    En total tengo "NUMERO DE REPLICAS" de cada PG

Al trabajar con ERASURE... cuantas copias tengo de cada PG?     Numero de trozos + Numero de trozos de reconstrucción
    Numero de trozos: 3
    Numero de trozos de reconstrucción: 2
    
    En total cada PG se guarda en 3 + 2 = 5 OSDs

Pool de tipo ERASURE:
    PG 17:  5 OSDs para ser almacenado:
    OSDs:
        20, 5, 119, 87, 324
        20      Trozos 1
        5       Trozos 2 * PUF !!!!!!
        119     Trozos 3
        87      Trozo de reconstrucción 1
        324     Trozo de reconstrucción 2
    Necesito alguien que reemplace al OSD 5... Elijo al 99
        20, ? , 199, 87, 324
        20, 99, 119, 87, 324        La palabra indep... me asgura que si se cae un OSD... entre otro en su lugar... manteniendo el orden

Si trabajase con Pools de tipo replicated: 3 replcias
    PG 17:  3 OSDs para ser almacenado:
    OSDs:
        20, 5 , 119
        20      Copia completa del objeto
        5       Copia completa del objeto * PUF !!!
        119     Copia completa del objeto
    Necesito alguien "nuevo"... no que reemplace al 5... sino OTRO. cualquiera: Elijo el 99
        20, 119, ?                  La palabra firstn... coge los OSD segun le vienen... da igual el orden... no se agura que se mantenga
        20, 119, ----99----. DEGRADED -> READY
        
Se ha jodido un OSD: 
    He perdido 18Tbs o 4 Tbs de datos
    
En ese OSD habrá dentro 120 PG ... Los PG son los que migran a otros OSDs

$ ceph osd erasure-code-profile get XXXXX
$ ceph osd erasure-code-profile set XXXXX \
        param=value
    k
    m
    crush-failure-domain
    crush-root
    crush-devi-class
    
    
Manager x 2

Sistema distribuido... en el sentido no de que los datos se guarden distribuidos: RADOS
                       en el sentido de que hay dentro distintos componentes que hacen distintas funciones.
                       Esos componentes se interrelacionan (comunican) entre si.
                       Pero puedo tenerlos instalados en diferentes sitios.
                       
Cluster CEPH: No penseis en ello como un conjunto de máquinas.
    Conjunto de procesos... claro, esos procesos corren en máquinas.
    Esos procesos corren en contenedores en máquinas.
    Los procesos ofrecen distinto tipo de servicios:
        mgr
            2 contenedores (cluster activo/pasivo)
        mon
            5 contenedores (cluster activo/activo)
        osd
            N mil contenedores.. van a su bola cada uno de ellos.
        mds
            M servicios.. los que queramos.
Lo que vamos a necesitar es máquinas donde alojar esos servicios.. realmente los demonios... los contenedores.

Cómo montamos esto en la realidad... 4 cpus 16 RAM 
6x4: 24 CORES
16x6: 96 GRM RAM

Todas nuestras máquinas están corriendo todo tipo de contenedors (demonios... de servicios)
Esto no es ni medio normal... aqui porque estamos en el curso.. en la realidad ni de coña.

Voy a poder agrupar demonios?
- mon   separados
- osds  separados: 1Tb de almacenamiento deberia tener 1Gb de RAM
- mgr + prometheus + grafana
- mds : separados


Si voy a montar varios FileSystems:
    
                    Se configura a través de un servicio MDS (YAML)
    FileSystem1 <> Demonio (contenedor) MDS sobre hierros con caracteristicas distintas POTENTE.       mds.clienteA.yaml      label: clienteA
    Filesystem2 <> Demonio (contenedor) MDS sobre hierros con caracteristicas distintas MENOS POTENTE  mds.clienteB.yaml
    
Mount -> Mon -> MDS -> OSD
            snapshots
            
Afinidad
$ ceph config set DEMONIO mds_join_fs FILESYSTEM
                  mds.clientea.a      fs_clienteA
$  ceph config set mds.clienteA.ip-172-31-11-2.eccezm  mds_join_fs  fs_clienteA

Un filesystem tiene a priori UN UNICO DEMONIO ACTIVO
Le puedo configurar demonios en Standby
$ ceph fs set FILESYSTEM allow_standby_replay true
    Lo que hacemos es que el filesystem tome 2 demonios de mds.
        Uno es el que tiene en activo.
        El otro le tiene en pasivo... pero vinculado a él... nadie más puede usar ese demonio como un demoino de standby. Lo he vinculado.
        Además, el demonio en pasivo (standby), está 100% entragado a la causa... Fijamente mirando ese filesystem, y al tanto de todas las operaciones.
        REPLICA.


Cuantos demonios deben existir en standby para que el filesystem esté funcionando con normalidad.
$ ceph fs set FILESYSTEM standby_count_wanted 1 
    Si no hay 1 daemon en standby disponible, consideralo unhealthy al filesystem