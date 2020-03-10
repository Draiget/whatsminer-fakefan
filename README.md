# Whatsminer Fake Fan
This script emulates fan speed values for cgminer and system (all that reading speed by /sys/class/fanspeed/ path)

# Installation
As a zero step you need to be able to edit system files, if you never run `mount -o remount,rw /` command, you should do this. That makes you able to write to ASIC filesystem, by default it is read only.

## As an init.d script
1. Copy **fake_fan_initd** from repo to the ASIC filesystem to `/etc/init.d/` directory using `scp` (for example `scp fake_fan_initd 192.168.1.120:/etc/init.d/fakefan`).
2. Run `chmod +x /etc/init.d/fakefan`.
3. Execute script `/etc/init.d/fakefan` manually or reload ASIC. Script will not start automatically after putting it to the `/etc/init.d/` folder.

## As a boot script part
1. Place `fake_fan.sh` from this repository to the remote asic `/etc` folder. You can run `scp` in case if you are using MacOS or another Unix system.
2. Then you need to give yourself a permissions for writing to `/etc/init.d/boot`, just run: `chmod +w /etc/init.d/boot`
3. Run following command:
```
sed -i.back -e 's|reload_config|reload_config\n\texec /etc/fake_fan.sh|g' /etc/init.d/boot
```
That basically will add `exec /etc/fake_fan.sh` to the end of `boot() {` function which is located in main `/etc/init.d/boot`.
4. That's all, now you can reboot cgminer (`kill -9 cgminer`) and check it out.

## Note
With this emulation intake and outtake (both), fans can be disconnected, there's no any checks that fans are installed, only cgminer will check the speeds of fans and prevent miner from starting without working fans.

Feel free to contact me through issues.