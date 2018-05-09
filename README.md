# mount-img

Easily mount a .img file on Linux

## Installation

```
npm install -g mount-img
```

or without npm

```
curl -fs https://raw.githubusercontent.com/mafintosh/mount-img/master/install | sh
```

## Usage

Use it just as you would mount but instead of passing a `/dev` device
pass a disk image file.

``` sh
mount-img my-image.img mnt
```

If you want to mount a specific partition from the image you can use the `-p` parameter.

``` sh
# mount partition 5
mount-mig my-image.img mnt -p 5
```

Per default it just mounts the first one.

## Creating image files

To create raw image files you can use fallocate

``` sh
# make a ~1gb image
fallocate my-image.img -l 1000000000
```

Then using `fdisk` you can make a partition table

``` sh
# to simply make a single partition, follow this
fdisk my-image.img
n<enter>
<enter>
<enter>
<enter>
w<enter>
```

You can also make more than one partition or make one bootable etc.

Then format the partition using ext4

``` sh
# note the Start sector
fdisk -l my-image.img
# change 2048 to the Start sector (usually 2048)
mkfs.ext4 -F -E offset=$((2048 * 512)) my-image.img
```

You can now mount this image using mount-img

``` sh
mount-img my-image.img mnt
```

Happy mounting!

## License

MIT
