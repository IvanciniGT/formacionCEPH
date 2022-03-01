    1  cd /etc/ceph/ceph.conf
    2  cd /etc/ceph
    3  ls
    4  cat caph.conf
    5  cat ceph.conf
    6  ls
    7  cp ceph.* /home/ubuntu/environment/curso/claves/
    8  chmod 777 -R /home/ubuntu/environment/curso/claves/
    9  hostname
   10  exit
   11  ceph version
   12  cephadm install ceph-common
   13  ceph version
   14  ceph status
   15  ceph orch ls
   16  ceph orch ps
   17  ceph orch ps --service-type mon
   18  ceph orch ps --service_type mon
   19  ceph orch ls --service_type mon
   20  ceph orch ps --daemon_type mon
   21  ceph orch ls --export
   22  ceph orch ls --export > /home/ubuntu/environment/curso/configuraciones/inicial.yaml
   23  sudo ceph orch apply osd --all-available-devices
   24  ceph orch ls
   25  ceph orch ps
   26  ceph orch ls
   27  ceph orch ps
   28  ceph orch ls
   29  ceph orch device ls
   30  ceph orch device ls --hostname=ip-172-31-11-2
   31  lsblk
   32  ceph orch daemon add osd ip-172-31-11-2:/dev/nvme1n1
   33  ceph orch device ls
   34  clear
   35  ceph orch ps
   36  ceph orch device ls
   37  ceph orch ps
   38  ceph orch device ls
   39  clear
   40  ceph orch device ls --wide
   41  ceph orch device ls
   42  history
   43  ceph orch ps
   44  ceph orch ls
   45  ceph orch ps
   46  ceph orch ls
   47  ceph status
   48  ceph orch apply osd --all-available-devices --unmanaged=true
   49  ceph orch host label add ip-172-31-11-2 ivan
   50  hostname
   51  lsblsk
   52  lsblk
   53  clear
   54  ceph orch device ls
   55  ceph orch device ls --wide
   56  çlvscan
   57  lvscan
   58  lvsdisplay
   59  lvs
   60  pvscan
   61  fdik -l
   62  fdisk -l
   63  cd /dev/disk/
   64  ls
   65  ls -l
   66  cd /home/ubuntu/environment/curso/configuraciones/
   67  ceph orch apply -i osds.yaml --dry-run
   68  ceph orch ls
   69  ceph orch ps
   70  ceph health detail
   71  ceph mgr module ls
   72  ceph mgr module ls | grep cephadm 
   73  ceph mgr module ls | grep cephadm  -A 20
   74  ceph mgr module disable cephadm
   75  ceph mgr module enable cephadm
   76  ceph health detail
   77  ceph orch apply -i osds.yaml --dry-run
   78  ceph mgr module disable cephadm
   79  ceph mgr module enable cephadm
   80  ceph health detail
   81  ceph mgr module disable cephadm
   82  ceph mgr module enable cephadm
   83  ceph health detail
   84  ceph orch apply -i osds.yaml --dry-run
   85  ceph mgr module disable cephadm
   86  ceph mgr module enable cephadm
   87  ceph orch apply -i osds.yaml --dry-run
   88  ceph health detail
   89  ceph orch apply -i osds.yaml --dry-run
   90  ceph health detail
   91  ceph orch apply -i osds.yaml --dry-run
   92  ceph health detail
   93  ceph orch apply -i osds.yaml --dry-run
   94  curl ifconfig.me
   95  history
   96  clear
   97  cd /home/ubuntu/environment/curso/configuraciones/
   98  ceph orch apply -i osds.yaml --dry-run
   99  history
  100  ceph orch apply -i osds.yaml --dry-run
  101  ceph orch host ls
  102  ceph orch apply -i osds2.yaml --dry-run
  103  fdisk -l
  104  ceph orch host ls
  105  ceph orch apply -i osds3.yaml --dry-run
  106  ceph orch apply -i osds4.yaml --dry-run
  107  ceph orch apply -i osds3.yaml --dry-run
  108  ceph orch host ls
  109  ceph orch apply -i osds3.yaml --dry-run
  110  ceph orch host ls
  111  ceph orch apply -i osds3.yaml --dry-run
  112  ceph orch apply -i osds.yaml --dry-run
  113  ceph orch ps
  114  ceph orch ls
  115  ceph orch apply -i osds.yaml --dry-run
  116  clear
  117  ceph orch ls
  118  ceph orch ls --service_name=miguel_osd --export
  119  ceph orch ls --service_name=osd.miguel_osd --export
  120  clear
  121  ceph orch apply -i osds.yaml --dry-run
  122  ceph orch apply -i osds.yaml
  123  ceph orch apply -i osds3.yaml
  124  ceph osd pool create ivan 256 replicated --autoscale-mode=warn
  125  ceph osd pool stats ivan
  126  ceph osd pool set ivan size 4
  127  ceph osd pool set ivan min_size 3
  128  ceph osch ls
  129  ceph orch ls
  130  clear
  131  ceph fs new ivan prueba1 ivan
  132  ceph orch ls
  133  ceph fs rm ivan
  134  ceph fs rm ivan --yes-i-really-mean-it
  135  ceph orch apply -i mds.yaml 
  136  ceph fs new ivan prueba1 ivan
  137  clear
  138  ceph mds stat
  139  apt install attr -y
  140  ceph fs authorize ivan        client.ivan                           /         rw
  141  ceph fs authorize ivan        client.ivan                           /         rw > /etc/ceph/ceph.client-ivan.keyring
  142  ceph fs authorize ivan        client.ivan                           /         rw > /etc/ceph/ceph.client.ivan.keyring
  143  ceph fs authorize ivan        client.ivan                           /         rw > /home/ubuntu/environment/curso/claves/ceph.client.ivan.keyring
  144  chmod 777 -R /home/ubuntu/environment/curso/claves/
  145  chmod 777 -R /home/ubuntu/environment/curso/claves
  146  ceph status
  147  ceph orch ps
  148  curl ifconfig.me
  149  ceph orch ps
  150  ceph fs dump
  151  ceph lspolls dump
  152  ceph lspools dump
  153  ceph pools dump
  154  ceph pool dump
  155  ceph pool
  156  ceph lspools
  157  ceph osd lspools
  158  ceph osd fs
  159  ceph orch fs dump
  160  ceph orch osd lspools
  161  clear
  162  ceph osd tree
  163  ceph mds tree
  164  clear
  165  ceph osd crush rule ls
  166  ceph osd crush rule dump
  167  ceph osd crush tree --show-shadow
  168  ceph osd crush add-bucket ivan rack
  169  ceph osd crush remove ivan
  170  ceph osd getcrushmap -o {compiled-crushmap-filename}
  171  ls
  172  rm \{compiled-crushmap-filename\} 
  173  ceph osd getcrushmap -o comiled.map
  174  crushtool -d swcomiled.map  -o comiled.map 
  175  apt install ceph-base
  176  crushtool -d swcomiled.map  -o comiled.map 
  177  ls
  178  ls -l
  179  cat -
  180  cat \-
  181  crushtool -d comiled.map  -o decomiled.map 
  182  cat decomiled.map 
  183  clear
  184  history
  185  clear
  186  netstat -lnt
  187  clear
  188  ceph osd tree
  189  ceph osd crush tree --show-shadow
  190  ceph osd crush add-bucket dc-ivan datacenter
  191  ceph osd crush move dc-ivan host=ip-172-31-11-2
  192  ceph osd crush move dc-ivan root=default
  193  ceph osd crush move ip-172-31-11-2 datacenter=dc-ivan
  194  ceph osd crush add-bucket sala1 room
  195  ceph osd crush move sala1 datacenter=dc-ivan
  196  ceph osd crush add-bucket rack1 rack
  197  ceph osd crush move rack1 datacenter=dc-ivan room=sala1
  198  ceph osd crush move ip-172-31-11-2 datacenter=dc-ivan room=sala1 rack=rack1 
  199  ceph osf crush set-device-class ssd osd.12
  200  ceph osd crush set-device-class ssd osd.12
  201  ceph osd crush set-device-class hdd osd.12
  202  ceph osd crush rm-device-class osd.12
  203  ceph osf crush set-device-class hdd  osd.12
  204  ceph osd crush set-device-class hdd  osd.12
  205  clear
  206  ceph osd crush rule ls
  207  #ceph osd getcrushmap -o /home/ubuntu/environment/
  208  mkdir -p /home/ubuntu/environment/curso/curshmap
  209  ceph osd getcrushmap -o /home/ubuntu/environment/curso/curshmap/compilado
  210  cd  /home/ubuntu/environment/curso/curshmap
  211  crushtool -d compilado -o crushmap
  212  ceph osd crush rule ls
  213  ceph osd crush rule dump
  214  ceph osd getcrushmap -o /home/ubuntu/emvironment/curso/crushmap/compilado
  215  ceph osd getcrushmap -o /home/ubuntu/environment/curso/crushmap/compilado
  216  ls /home/ubuntu/environment/curso/crushmap/compilado
  217  ls /home/ubuntu/environment/curso/crushmap
  218  ls /home/ubuntu/environment/curso
  219  ceph osd getcrushmap -o /home/ubuntu/emvironment/curso/crushmap/compilado
  220  ceph osd getcrushmap -o /home/ubuntu/environment/curso/crushmap/compilado
  221  crushtool -d /home/ubuntu/emvironment/curso/crushmap/compilado -o /home/ubuntu/emvironment/curso/crushmap/crushmap
  222  crushtool -d /home/ubuntu/environment/curso/crushmap/compilado -o /home/ubuntu/environment/curso/crushmap/crushmap
  223  ceph osd set-device-class hdd osd.13
  224  ceph osd crush set-device-class hdd osd.13
  225  ceph osd crush rm-device-class osd.13
  226  ceph osd crush set-device-class hdd osd.13
  227  ceph osd crush rule create-replicated regla_ivan sala1 rack
  228  ceph osd crush rule ls
  229  ceph osd crush rule dump
  230  history
  231  history | pool
  232  history | grep pool
  233  clear
  234  ceph osd crush rule rm regla_ivan
  235  ceph osd crush rule ls
  236  ceph osd crush rule create-replicated regla_ivan default room
  237  ceph osd crush rule ls
  238  ceph osd crush rule dump
  239  ceph osd crush rule rm regla_ivan
  240  ceph osd crush rule create-replicated regla_ivan default datacenter
  241  ceph osd crush rule rm regla_ivan
  242  ceph osd crush rule create-replicated regla_ivan
  243  ceph osd crush rule create-replicated regla_ivan default
  244  ceph osd crush rule create-replicated regla_ivan default host
  245  ceph osd crush move dc-leyre root=default
  246  ceph osd crush rule create-replicated regla_ivan default room
  247  ceph osd crush rule rm regla_ivan
  248  ceph osd crush rule create-replicated regla_ivan default room
  249  ceph pg dump
  250  ceph pg dump > /home/ubuntu/environment/curso/monitoring/pgs.txt
  251  w
  252  who
  253  ps -ef |grep bash
  254  ceph pg dump 
  255  ceph osd getcrushmap -o /home/ubuntu/environment/curso/crushmap/compilado
  256  crushtool -d /home/ubuntu/environment/curso/crushmap/compilado -o /home/ubuntu/environment/curso/crushmap/crushmap 
  257  df -h
  258  chmod 777 /home/ubuntu/environment/curso/crushmap
  259  df -h
  260  chmod 777 /home/ubuntu/environment/curso/crushmap/crushmap 
  261  clear
  262  #crushtool -d /home/ubuntu/environment/curso/crushmap/compilado -o /home/ubuntu/environment/curso/crushmap/crushmap 
  263  #crushtool -c /home/ubuntu/environment/curso/crushmap/crushmap -o /home/ubuntu/environment/curso/crushmap/compilado
  264  ls -l /home/ubuntu/environment/curso/crushmap
  265  rm  /home/ubuntu/environment/curso/crushmap/compilado
  266  crushtool -c /home/ubuntu/environment/curso/crushmap/crushmap -o /home/ubuntu/environment/curso/crushmap/compilado
  267  ls -l /home/ubuntu/environment/curso/crushmap
  268  ceph osd setcrushmap -i /home/ubuntu/environment/curso/crushmap/compilado
  269  echo $?
  270  ceph osd crush rule ls
  271  ceph osd crush rule dump
  272  history
  273  history > /home/ubuntu/environment/curso/comandos.sh
