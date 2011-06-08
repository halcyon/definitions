       Veewee::Session.declare( {
        :cpu_count => '1', :memory_size=> '1024', 
        :disk_size => '1048576', :disk_format => 'VDI', :hostiocache => 'on' ,
        :os_type_id => 'Oracle_64',
        :iso_file => "Enterprise-R5-U6-Server-x86_64-dvd.iso", :iso_src => "", :iso_md5 => "156e9a02bf326b4af1734e7df40f6657", :iso_download_timeout => 1000,
        :boot_wait => "10",:boot_cmd_sequence => [ 
          		          'linux text ks=http://%IP%:%PORT%/ks.cfg<Enter>' 				  
          ],
        :kickstart_port => "7122", :kickstart_timeout => 10000,:kickstart_file => "ks.cfg",
        :ssh_login_timeout => "100",:ssh_user => "vagrant", :ssh_password => "vagrant",:ssh_key => "",
        :ssh_host_port => "7222", :ssh_guest_port => "22",
        :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
        :shutdown_cmd => "/sbin/halt -h -p",
        :postinstall_files => [ "postinstall.sh"],:postinstall_timeout => 10000
         }
      )
