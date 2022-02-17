curl --silent --remote-name --location https://github.com/ceph/ceph/raw/pacific/src/cephadm/cephadm

chmod +x cephadm

sudo cephadm add-repo --release pacific

sudo ./cephadm install

                            # Red publica
#cephadm bootstrap --mon-ip=172.31.11.2
sudo cephadm bootstrap --mon-ip $(hostname -I | cut -d' ' -f1)

# Abrirnos un contenedor con la configuración de nuestro cluster para usar el cliente
sudo cephadm shell 




thisisunsafe