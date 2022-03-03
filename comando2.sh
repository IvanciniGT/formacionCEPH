    1  uname -a
    2  whoami
    3  pwd
    4  ls
    5  ls
    6  df -h
    7  docker --version
    8  docker images
    9  docker images -q
   10  docker rmi $(docker images -q)
   11  df -h
   12  df -h
   13  lsblk
   14  sudo growpart /dev/nvme0n1 1
   15  lsblk
   16  df -h
   17  sudo resize2fs /dev/nvme0n1p1
   18  df -h
   19  clear
   20  ps -eaf
   21  clear
   22  docker --version
   23  python3
   24  python --version
   25  python3 --version
   26  docker run --rm -d --name miapache httpd
   27  docker ps 
   28  curl 172.17.0.2
   29  docker stop miapache
   30  curl 172.17.0.2
   31  docker stop miapache
   32  docker run --rm -d --name miapache httpd
   33  docker network list
   34  ps -eaf | grep httpd
   35  ps -eaf | grep runc
   36  docker logs miapache
   37  curl 172.17.0.2
   38  docker logs miapache
   39  curl 172.17.0.2
   40  curl 172.17.0.2
   41  curl 172.17.0.2
   42  docker logs miapache
   43  clear
   44  docker ps 
   45  free
   46  clear
   47  curl 172.17.0.2
   48  docker stop miapache
   49  docker run --rm -d --name miapache -p 172.31.11.2:8888:80 httpd
   50  cd curso
   51  git init 
   52  git add :/
   53  git commit -m 'Alta del proyecto'
   54  git config --global credential.helper store
   55  git remote add origin https://github.com/IvanciniGT/formacionCEPH.git
   56  git push
   57  git push --set-upstream origin master
   58  cd instalacion/
   59  curl --silent --remote-name --location https://github.com/ceph/ceph/raw/pacific/src/cephadm/cephadm
   60  chmod +x cephadm 
   61  cephadm add-repo --release pacific
   62  export PATH=$PATH:.
   63  sudo cephadm add-repo --release pacific
   64  ls -l
   65  echo $PATH
   66  sudo ./cephadm add-repo --release pacific
   67  sudo aput update
   68  sudo apt update
   69  ./cephadm install
   70  sudo ./cephadm install
   71  which cephadm
   72  docker ps
   73  docker stop miapache
   74  clear
   75  docker ps
   76  clear
   77  sudo cephadm bootstrap -h
   78  echo $(hostname -I | cut -d' ' -f1)
   79  sudo cephadm bootstrap --mon-ip $(hostname -I | cut -d' ' -f1)
   80  clear
   81  ip a
   82  netstat -lnt
   83  docker ps
   84  docker inspect fc64bb34f522
   85  sudo ceph orch ps
   86  docker ps
   87  sudo cephadm shell
   88  netstat -lnt
   89  echo https://$(curl ifconfig.me):8443
   90  sudo su -
   91  cd curso
   92  git add :/
   93  git commit -m 'configuracion y claves'
   94  git push
   95  git pull
   96  ssh root@ip-172-31-11-154
   97  ssh root@ip-172-31-1-135
   98  ssh root@ip-172-31-12-180
   99  ssh root@ip-172-31-3-193
  100  ssh root@ip-172-31-11-174
  101  history
  102  sudo cephadm shell
  103  history
  104  echo https://$(curl ifconfig.me):8443
  105  curl ifconfig.me
  106  cd curso
  107  git add :/
  108  git commit -m 'osds'
  109  git push
  110  clear
  111  sudo su -
  112  curl ifconfig.me
  113  clear
  114  w
  115  ps -ef |grep bash
  116  who
  117  w
  118  sudo -i
  119  id
  120  ls
  121  history
  122  sudo -i
  123  exit
  124  sudo su -
  125  cd curso
  126  git add :/
  127  git commit -m 'dia 8'
  128  git push
  129  curl ifconfig.me
  130  sudo su -
  131  curl ifconfig.me
  132  cephfs-shell
  133  sudo apt install cephfs-shell
  134  cp cephfs-shell.conf ~/.cephfs-shell.conf
  135  cephfs-shell
  136  sudo cephfs-shell
  137  clear
  138  cephfs-shell -h
  139  cephfs-shell -h
  140  cephfs-shell 
  141  quota
  142  sudo cephfs-shell
  143  sudo cephfs-shell --help
  144  clear
  145  cp curso/configuraciones/cephfs-shell.conf ~/.cephfs-shell
  146  cephfs-shell --help
  147  cephfs-shell
  148  sudo cephfs-shell
  149  ls /etc/ceph
  150  ls /etc/ceph/ceph.conf 
  151  cat /etc/ceph/ceph.conf 
  152  sudo cephfs-shell
  153  ls /etc/ceph/ceph.conf 
  154  ls /etc/ceph
  155  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  156  helm
  157  helm repo add rook-master https://charts.rook.io/master
  158  helm pull rook-master/rook --untar
  159  helm repo update
  160  helm pull rook-master/rook --untar
  161  helm search rook
  162  helm search rook
  163  helm pull rook-master/rook --version v0.6.0-156.gef983d6
  164  helm pull rook-master/rook --version v0.6.0-156.gef983d6 --untar
  165  helm template rook-master/rook --version v0.6.0-156.gef983d6
  166  cd curso
  167  history > comando2.sh
