# Contenedores

Un entorno aislado donde ejecutar procesos dentro de un SO Linux.

Entorno aislado:
- Van a tener su propia configuración de red
- Van a tener su propio sistema de archivos
- Van a tener sus propias variables de entorno
- Van a tener limitación de acceso al Hierro

# Instalación

## Forma clásica
    
    App 1 | App 2 | App 3           Inconvenientes: 
    ---------------------               - Comparte misma conf. SO... Incompatibilidades
            SO                          - Que pasa si una app tiene un bug? app1 100% CPU
    ---------------------                                                   me jode todo
          Hierro                        - Incompatibilidad de dependencias
    
    c:\archivos de programa\office > *.zip > email

## Máquinas virtuales 
 
      App1  | App2 + App3
    ---------------------           Inconvenientes:
      SO    |     SO                    - Desperdicio de recursos: RAM, CPU
    ---------------------               - Peor rendimiento en la ejecución
      MV 1  |    MV 2                   - Madre mia... la que me ha liao...
    ---------------------                   N SOs... a mantener, instalar, actualizar, config.
   Hipervisor: vmware, citrix,
 kvm, hyperV, oracle virtualBox
    ---------------------
            SO
    ---------------------
          Hierro

## Contenedores? Explota en el año 2013 - docker
    
     App1 |  App 2 + App3
    ---------------------
       C1 |    C2    
    ---------------------
    gestor de contenedores: docker
    ---------------------
        SO LINUX (kernel)
    ---------------------
          Hierro

Hoy en dia los contenedores son la forma estándar de instalar cosas en los entornos de producción.
Los contenedores se crean desde una IMAGEN DE CONTENEDOR.

Existe un estándar de como son los contenedores y como ejecutarlos y como crear imagenes de contenedor:


## Imágen de Contendor

Un triste fichero comprimido (.tar), que tiene dentro:

- Tiene una estructra de carpetas POSIX:
    /bin
    /home
    /opt
        programa ya instalado y configurado por alguien
    /var
    /tmp
    /etc
        Archivos de configuración < Yo a posteriori puedo mangonear....
El programa al arrancar va a tomar configuraciones de las variables de entorno.

Las imágenes de contenedores se alojan en "registries" de repositorios de imágenes de contenedor.
    Registry más famoso: docker hub
    Registry más famoso: quay.io      < Redhat   

## Gestores de contenedores: docker, podman(RHEL), CRIO, containerd

## Tipos de software
- Servicios     |
- Demonios       > Se puede ejecutar en contenedores 
- Scripts       |
- Comandos      |
------------------------------------------------------ 
- Aplicación    : Photoshop
- Drivers       : Driver de una tarjeta grafica
- SO            : Ubuntu

# Gestor de gestores de contenedores

Kubernetes / K8S K3S Openshift(Redhat)

Cluster máquinas
Maquina 1
    docker / podman
Maquina 2
    docker / podman
Maquina 3
    docker / podman
Maquina 4
    docker / podman



ceph orch ps


# docker / podman

Pueden crear redes lógicas o "virtuales"

loopback : 127.0.0.1 localhost
docker:    172.17.0.0./16 < red logica

Maquina 1 ------|
    mon         |
    osd (disco) |
Maquina 2 ------|
    osd (disco) |
Maquina 3 ------|
    mon         |
    mds         |---Cliente (Ordenador montado nfs) Crush Map
    mgr


chroot


ceph