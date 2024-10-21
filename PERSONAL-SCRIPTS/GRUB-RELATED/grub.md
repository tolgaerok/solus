### GRUB
- use `alias grub-mod="sudo nano /etc/kernel/cmdline.d/mitigations.conf"`

```bash
io_delay=none rootdelay=0 iomem=relaxed mitigations=off

```
