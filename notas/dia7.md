Crush Map
- Arbol con la estructura jerárquica de nuestro cluster (OSDs)

root:
    hosts:
        OSDs
        
zone room row rack chassis        

OSDs < PG  replicas
PG(n) > OSD
Me puede interesar que su replica esté en otro OSD (minimo)
Me interesa el original y la replicia del PG en 2 OSDs del mismo host? NO (defecto hace ceph)

En el crush map, podemos definir conjuntos de reglas. Esas reglas se aplican sobre la elección de los OSDs
    que albergarán los PG (y sus replicas) de un determinado Pool (o varios)
Por defecto el ruleset que hay configurado en CEPH elije los OSDs en distitntos HOSTS para las replicias.







# rules
rule replicated_rule {
	id 0                                # Es un id interno... ni le miramos
	type replicated                     # Indica sobre que tipo de pool esto puede aplicar
	min_size 1                          # Min y máximo de replicas que puede tener configurado un 
	max_size 10                         # pool para poder usar esta regla
	
	# Aquí es donde está la gracia y LO QUE HAY QUE CAMBIAR:
	
	# Elegir un BUCKET DEL ARBOL DE CRUSH
	step take default                       # Ponte arriba del todo del arbol
#	step take sala1                         # Ponte en el nodo sala1
	step take NOMBRE-DE-UN-BUCKET class TIPO_DISPOSITIVO (ssd|hdd|nvme)

	# Elegir un/unos OSDs para albergar un PG y sus replicias
	step chooseleaf firstn 0 type host     # Busca UN NUMERO DE subnodos de tipo host (allá donde estén por debajo)
	                                       # Cuantos OSDs 
	                                            0               > Tantos como replicas se hayan solicitado en el pool
	                                            NUMERO POSITIVO > Las que te indico
	                                            NEGATIVO        > Tantas como replicas se haya solicitado menos las que te indico

	# Confirmamos la selección
	step emit
}


He creado un pool... Que tiene 2 PG y quiero 3 replicas.
Cuantas veces se aplica el rule?                                        Se aplica 2 veces.
Cada vez que se aplica la regla... cuantos OSDs se van a elegir?        3 OSDs = Número de replicas del pool
Cómo se aplica la regla:
    1- Colocate en el nodo raiz (default)
    2- chooseleaf: Elige por debajo nodos:
       type host: de tipo host.... 
       0: En total 3
    3- De cada uno de esos nodos (hosts), dame un OSD

Que las 3 replicas van a ir a 3 hosts diferentes

La palabra firstn: VA DE SERIE CUANDO TRABAJAMOS CON POOLS REPLICATED
Si en lugar de pools replicated trabajo con ERASURE, pondría indep

chooseleaf|choose.  SIEMPRE USO CHOOSELEAF.. La otra como si n o existiera.

PLANTILLA: 
step take NOMBRE-DE-UN-BUCKET class TIPO_DISPOSITIVO (ssd|hdd|nvme)
step chooseleaf firstn CUANTAS-OSDs-DENTRO-DEL-BUCKET type TIPO_BUCKET

# Quiero una regla que haga que las repilcias de los PG se guarden en rooms diferentes.
	step take default                       # Desde arriba del todo
	step chooseleaf firstn 0 type room      # Elige tantas rooms como replicas... De cada una (room) saca un OSD.
	step emit

# Quiero una regla que haga que las repilcias de los PG se guarden en rooms diferentes, pero en discos SSD
	step take default class ssd             # Desde arriba del todo
	step chooseleaf firstn 0 type room      # Elige tantas rooms como replicas... De cada una (room) saca un OSD.
	step emit

# Quiero una regla que haga que las repilcias de los PG se guarden en rooms diferentes, 
# Una replica en un SSD , el resto de replicas en HDD 
        Me penalizaría en escritura? Depende.....
            Donde se guarda el dato para que un OSD dé la confirmación? en el WAL. Si el WAL es SSD ... no penaliza.
            
	step take default class ssd             
	step chooseleaf firstn 1 type room      --> room 17
	step emit
	step take default class hdd             
	step chooseleaf firstn -1 type room      --> room 5, room 17
	step emit
	
Puedo tener un problema?
    Estamos haciendo 2 selecciones. Para cada una, ceph asegura que se extraigan nodos UNICOS... PARA CADA UNA !!!
    
clienteA -> buckets de tipo cliente
clienteB -> buckets de tipo cliente


# Quiero un pool que guarde los datos en los discos de 3 maquinas... que son las del cliente
- Crear una regla (rule de crush) para ese pool
- En la infra (crush map), defino un bucket de tipo cliente: clienteX
- Dentro del clienteX pongo los hosts
- Configuro la regla:
    step take clienteA
	step chooseleaf firstn 0 type host
	step emit

# Qué consigo con esto?
- Ventajas:
    - Limito el cliente a unos hosts concretos... y eso me permite que un cliente no "joda" a otros en rendimiento.
- Inconvenientes:
    - Tengo todos los huevos en la misma cesta
    - Todos los datos del cliente los tengo en X discos duros. Siendo X pequeñito.
            - Si se cae una maquina o un HDD... CUIDADO... quedan pocas alternativas
        - Si sus datos se están repartiendo entre el total de máquinas del cluster... el que caiga una máuina, no tiene por qué provocar un gran impacto.

500 HDD -> 100HDD

¿Esto sería una forma de controlar que un cliente no guarde más datos del tamaño que me tiene contratado, o por el que me paga?
SI... pero la correcta sería con las quotas, que para eso están.


hdd sdd

Si quiero que un pool guarde los datos solo en un tipo de disco.
Si quiero que un pool guarde los datos en varios tipos de disco:
    - Explicitarlo en el rule
    - Si no lo explicito. VAmos jodidos... porque los ssd van a tender a usarse menos... por ser mas pequeños.

De todas los PGs replicados que se montan de un POOL, quien se considera el primario.
A éste se le ataca siempre. Él (el primario), luego, manda los datos a los replicados.
El primero que se elige de la lista. Nos interesa eso? Hay OSDs que por ser los primeros de la lista... se me van a petar de peticiones (en LECTURA y escritura)
HOST 1          PESO                                    PESO-A-LA-HORA-DE-SER-ELEGIDO-PRIMARIO
    OSD 1       1           A_PG1(1)* Primaria                  1
    OSD 2       1           B_PG1(1)* Replica                   0
HOST 2
    OSD 3       1           A_PG1(2)* Replcias                  1
    OSD 4       1           B_PG1(2)* PRIMARIO                  1
HOST 3
    OSD 5       1           A_PG1(3)* Replcias                  1
    OSD 6       1           B_PG1(3)* Replcias                  1
Quiero 3 replcias de un pool A, que tiene 2 pg-> 6 pgs: 2 primarios + 4 replicas
Quién se come el marrón de las peticiones? A quién atacan los clientes? HOST 1. La CPU... se le pone calentita.. y la RAM igual
    Bajar la probabilidad de que el OSD2 sea primario

$ ceph osd primary-affinity osd.2 0

PESO: Sirve para determinar con que probabilidad un PG entra en un OSD
En ocasiones queremos cambiar el peso de un OSD, para un POOL. 
Tengo un pool que va a ser pequeño en cantidad de información, pero quiero que vaya fino... y quiero que ciertos discos, 
tengan más probabilidad de albergar pg pero para ese pool
PER-POOL WEIGHT.
Para esto, lo primero es decir que un pool va a tener sus propios pesos, independientes de los generales.

$ ceph osd weight-set create POOL           # Activar que el pool X tenga sus propios pesos, idependientes de los genericos definidos en el CRUSHMAP
$ ceph osd weight-set reweight POOL OSD PESO
$ ceph osd weight-set ls
$ ceph osd weight-set rm POOL

POOL
RULE: los datos en un room, dentro del room se elijan los host. << PROBLEMAS 
>
RULE NUEVO: Guardar datos, filtro por room. (FAILURE) Cada replica en un room
En las máquinas tenemos discos de distinta naturaleza... aunque no se han reconocido por ceph.
    Etiquetado correcto de los tipos de OSDs    
$ ceph osd crush set-device-class TIPO OSD
$ ceph osd crush rm-device-class OSD
RULE: Los datos los queremos en SSDs

RULE: Los datos, queremos, una PG en un SDD, y sus replicas en HDDs


$ ceph osd crush rule create-replicated NOMBRE-REGLA RAIZ A-QUE-NIVEL-QUIERO-PROTECCION-FALLAS TIPO-DISPOSITIVO
	step take RAIZ class TIPO-DISPOSITIVO
	step chooseleaf firstn 0 type A-QUE-NIVEL-QUIERO-PROTECCION-FALLAS      
	step emit
	
EJEMPLO:

$ ceph osd crush rm-device-class osd.13
$ ceph osd crush set-device-class hdd osd.13
$ ceph osd crush rule create-replicated regla_ivan sala1 rack
 Al crear el pool ivan2... con la regla regla_ivan, me da problemas... me dice que solo puedo poner 1 replica 
$ ceph osd crush rule rm regla_ivan
$ ceph osd crush rule create-replicated regla_ivan default room

OJO... el crush map estaba mal... y los datacenter no colgaban del root
Para moverlos:
$ ceph osd crush move dc-leyre root=default
