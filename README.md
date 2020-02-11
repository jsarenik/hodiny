# hodiny
Minimal, mostly statical http://clock.zone fork.

## Requirements

- [`busybox`](https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/)
  - with `sed`, `date`, `awk`, `httpd`, `sh`
- [`timestamp`](timestamp.c) (included - see `timestamp.c`)
- [`uglifyjs`](https://www.npmjs.com/package/uglify-js)

## Notes

There are 4 main scripts and they all end with `.php` extension
because originally they were written in PHP (see [mail from Igor](doc/mail.txt)).
In this repository they are actually shell scripts which make use of `timestamp`
and `busybox`, both installed in `/busybox`.

Another script is `widget/digit.php` used only in the Widget mode.

The additional `cgi-bin/index.cgi` shell script is used to generate the analog clock.

See the commit messages from the beginning to learn more details.
