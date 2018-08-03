# Whatsminer Fake Fan
This script emulates fan speed values for cgminer and system (all that reading speed by /sys/class/fanspeed/ path)

# Installation
1. As a first step you need to be able to edit system files, if you never run `mount -o remount,rw /` command, you should do this. That make you able to write to ASIC filesystem, by default it is read only.
2. Place `fake_fan.sh` from this repository to remote asic `/etc` folder. You can run `scp` if you using MacOS or other Unix system.
3. Then you need to give yourself a permissions for writing to `/etc/init.d/boot`, just run: `chmod +w /etc/init.d/boot`
4. Add `exec "/etc/fake_fan.sh"` to function `boot() {` which is located at the very bottom of the file `/etc/init.d/boot`. 
Example:
```sh
boot() {
	[ -f /proc/mounts ] || /sbin/mount_root
	[ -f /proc/jffs2_bbc ] && echo "S" > /proc/jffs2_bbc
	[ -f /proc/net/vlan/config ] && vconfig set_name_type DEV_PLUS_VID_NO_PAD

	mkdir -p /var/run
	mkdir -p /var/log
	mkdir -p /var/lock
	mkdir -p /var/state
	mkdir -p /var/tmp
	mkdir -p /tmp/.uci
	chmod 0700 /tmp/.uci
	touch /var/log/wtmp
	touch /var/log/lastlog
	touch /tmp/resolv.conf.auto
	ln -sf /tmp/resolv.conf.auto /tmp/resolv.conf
	grep -q debugfs /proc/filesystems && /bin/mount -o noatime -t debugfs debugfs /sys/kernel/debug
	[ "$FAILSAFE" = "true" ] && touch /tmp/.failsafe

	/bin/board_detect
	uci_apply_defaults

	do_for_allwinner
	set_reset_directions
	set_plug_directions
	set_en_directions
	init_led

  prepare_logs_partition

	# temporary hack until configd exists
	/sbin/reload_config

	# create /dev/root if it doesn't exist
	[ -e /dev/root -o -h /dev/root ] || {
		rootdev=$(awk 'BEGIN { RS=" "; FS="="; } $1 == "root" { print $2 }' < /proc/cmdline)
		[ -n "$rootdev" ] && ln -s "$rootdev" /dev/root
	}

	exec "/etc/fake_fan.sh"
}
```

That's all, now you can reboot cgminer and check it out.

## Note
With this emulation and outtake, fans can be disconnected, there's no any checks that fans are installed, only cgminer will check the speeds of fans and prevent miner from starting without working fans.

Feel free to contact me through issues.
