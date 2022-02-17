# CEPH STORAGE

## Qué es CEPH Storage?

Sistema distribuido de almacenamiento de qué?
    - Objetos?
Para qué lo puedo usar en la práctica? Para tener un sistema de almacenamiento de?
    - FileSystem | Archivos | NFS 
    - Bucket S3 | REST: JSON
    - Almacenamiento de Imagenes de FileSystem de VMs: BLOQUES

Qué más características tiene?
    - Facilmente escalable
    - Robusto... autocurativo... relilente
    - Se autogestiona
    - De alto rendimiento

Licencia?
    Ceph Opensource y Gratuito. LGPL
        Qué empresa detrás... Redhat
    RH Ceph... de pago bajo modelo de subscripción
    
Redhat:
        upstream
Proyecto gratuito           >     Proyecto de pago (mediante subscripción)
fedora                      >        RHEL
wildfly                     >        jboss
open shift origin (OKD)     >     RH openshift container platform
openstack                   >     RH openstack 
    -> Me sirve para montar un cloud privado (AWS)

## Cuando trabajamos con CEPH vamos a manejar un CLUSTER:

Cluster máquinas CEPH:
    
    Maquina 1
        mon -----
                |
    Maquina 2   |
        mon -----   Cluster de monitorizadores Mínimo: 3? Quorum (split de red) Evitar brain splitting
                |                                      5
    Maquina 3   |                                      11
        mon -----
        manager < VA A CORRER DENTRO DE UN CONTENEDOR
        
    Maquina 4
        osd
        nfs

## Instalación

La instalacion recomendada es mediante contenedores docker/podman
    o Kubernetes (crio, containerd)

## Requerimientos

- docker (debian, ubuntu, suse) o podman (rhel, fedora, centOS, oracleLinux)
- python3
- lvm2
- ntp

# La instalación se hace en 1 nodo... SOLO EN UN NODO.

Bootstrap del cluster

