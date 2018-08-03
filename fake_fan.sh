#!/bin/sh

WORK_DIR="/etc/fake_fan"
FAN_SPEED=6001
FAN_PWM=75

# Initialize
mount -o remount,rw /
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "$FAN_SPEED" > fan1speed
echo "$FAN_SPEED" > fan0speed

echo "$FAN_PWM" > pwm0_duty
echo "$FAN_PWM" > pwm1_duty
echo "$FAN_PWM" > pwm_duty

# Clean if we already run this script
umount "/sys/class/fanspeed/" > /dev/null
mount --bind "$WORK_DIR" /sys/class/fanspeed/

logger -t fake_fan "Fake path mounted"