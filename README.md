# update G7 iso

update iso without restart:

<pre>
$ ./G7_update_iso.sh 192.168.168.192 
</pre>

update iso with restart:

<pre>
$ ./G7_update_iso.sh 192.168.168.152 --restart
</pre>

<pre>
/c/Users/greenbox/.docker/machine/machines/greenbox
total 1852193
-rw-r--r-- 1 greenbox None   34603008 May 12 09:30 boot2docker.iso
-rw-r--r-- 1 greenbox None   34603008 May 12 09:29 boot2docker.iso.orig
-rw-r--r-- 1 greenbox None       1038 May 12 08:59 ca.pem
-rw-r--r-- 1 greenbox None       1078 May 12 08:59 cert.pem
-rw-r--r-- 1 greenbox None       3011 May 12 08:59 config.json
-rw-r--r-- 1 greenbox None 1826750464 May 12 09:33 disk.vmdk
drwxr-xr-x 1 greenbox None          0 May 12 09:27 greenbox
-rw-r--r-- 1 greenbox None       1675 Apr 27 17:27 id_rsa
-rw-r--r-- 1 greenbox None        381 Apr 27 17:27 id_rsa.pub
-rw-r--r-- 1 greenbox None       1679 May 12 08:59 key.pem
-rw-r--r-- 1 greenbox None       1679 May 12 08:59 server-key.pem
-rw-r--r-- 1 greenbox None       1115 May 12 08:59 server.pem
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
greenbox-4.5.9.iso                                                                                                                 100%   33MB   2.8MB/s   00:11    
total 1851617
-rw-r--r-- 1 greenbox None   34603008 May 12 09:42 boot2docker.iso
-rw-r--r-- 1 greenbox None   34603008 May 12 09:42 boot2docker.iso.orig
-rw-r--r-- 1 greenbox None       1038 May 12 08:59 ca.pem
-rw-r--r-- 1 greenbox None       1078 May 12 08:59 cert.pem
-rw-r--r-- 1 greenbox None       3011 May 12 08:59 config.json
-rw-r--r-- 1 greenbox None 1826816000 May 12 09:42 disk.vmdk
drwxr-xr-x 1 greenbox None          0 May 12 09:42 greenbox
-rw-r--r-- 1 greenbox None       1675 Apr 27 17:27 id_rsa
-rw-r--r-- 1 greenbox None        381 Apr 27 17:27 id_rsa.pub
-rw-r--r-- 1 greenbox None       1679 May 12 08:59 key.pem
-rw-r--r-- 1 greenbox None       1679 May 12 08:59 server-key.pem
-rw-r--r-- 1 greenbox None       1115 May 12 08:59 server.pem
Executing (\\DESKTOP-2J70KM8\ROOT\CIMV2:Win32_OperatingSystem=@)->Reboot()
Method execution successful.
Out Parameters:
instance of __PARAMETERS
{
	ReturnValue = 0;
};
</pre>

