```bash
# /etc/fstab: static file system information....
#
# Use 'blkid' to print the universally unique identifier for a device; this may
# be used with UUID= as a more robust way to name devices that works even if
# disks are added and removed. See fstab(5).
#
# <file system>             <mount point>  <type>  <options>  <dump>  <pass>
UUID=44690b9e-3048-4f9a-a75e-5e5256e21a81 /              btrfs   subvol=/@,defaults,noatime,lazytime 0 0
UUID=44690b9e-3048-4f9a-a75e-5e5256e21a81 /home          btrfs   subvol=/@home,defaults,noatime,lazytime 0 0
tmpfs                                     /tmp           tmpfs   defaults,noatime,mode=1777 0 0


```