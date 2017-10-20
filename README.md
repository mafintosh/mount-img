# mount-img

Easily mount a .img file on Linux

```
npm install -g mount-img
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

Happy mounting!

## License

MIT
