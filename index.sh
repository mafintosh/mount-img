#!/usr/bin/env bash

PARTITION=""
FORCE=false
READ_ONLY=""

set_image_or_mnt () {
  if [ "$IMAGE" == "" ]; then
    IMAGE="$1"
  else
    MNT="$1"
  fi
}

silent () {
  "$@" 2>/dev/null >/dev/null
}

while [ "$1" != "" ]; do
  case "$1" in
    --dry-run)   DRY_RUN=echo; shift ;;
    --partition) PARTITION="$2"; shift; shift ;;
    -p)          PARTITION="$2"; shift; shift ;;
    --force)     FORCE=true; shift;;
    -f)          FORCE=true; shift;;
    --read-only) READ_ONLY="--read-only"; shift;;
    -r)          READ_ONLY="--read-only"; shift;;
    *)           set_image_or_mnt "$1"; shift ;;
  esac
done

if [ "$IMAGE" == "" ] || [ "$MNT" == "" ]; then
  echo "Usage: mount-img <image> <mnt> [options]"
  echo
  echo " --partition, -p [partition-number]"
  echo " --force, -f     (force mount)"
  echo " --read-only, -r (read-only mount)"
  echo
  exit 1
fi

if ! [ -f "$IMAGE" ]; then
  echo "$IMAGE" is not a file
  exit 2
fi

if ! [ -d "$MNT" ]; then
  echo "$MNT" is not a directory
  exit 2
fi

if $FORCE; then
  $DRY_RUN silent sudo umount "$MNT"
fi

IFS=$'\n'

for line in $(fdisk -l "$IMAGE" | grep "$IMAGE$PARTITION" | grep -v "Disk $IMAGE"); do
  OFFSET=$(echo $line | sed 's|\*||' | awk '{print $2}')
  SECTORS=$(echo $line | sed 's|\*||' | awk '{print $4}')
  break
done

if [ "$OFFSET" == "" ] && [ "$SECTORS" == "" ] && [ "$PARTITION" != "" ]; then
  echo Could not find partition
  exit 3
fi

if [ "$OFFSET" == "" ]; then
  $DRY_RUN sudo mount $READ_ONLY -o loop "$IMAGE" "$MNT"
else
  $DRY_RUN sudo mount $READ_ONLY -o loop,offset=$(($OFFSET * 512)),sizelimit=$(($SECTORS * 512)) "$IMAGE" "$MNT"
fi
