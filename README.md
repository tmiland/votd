# Verse of the Day
A small bash script to print Bible Gateway's Verse of the Day in KJV

## Installation

#### Download and execute the script:

```bash
$ wget https://github.com/tmiland/votd/raw/master/votd.sh
$ chmod +x votd.sh
$ ./votd.sh
```

#### Optionally

 ```bash
$ ln -s /path/to/votd.sh /usr/bin/votd
$ votd
```

#### Or add it to motd

```bash
$ ln -s /path/to/votd.sh /etc/update-motd.d/10-votd
$ /usr/sbin/update-motd
```
***Requires the update-motd package***

`apt install update-motd`

## Screenshots
![screenshot](https://raw.githubusercontent.com/tmiland/votd/master/votd.png)

## Credits
- Code is forked from:
  * [github.com/mztriz/votd](https://github.com/mztriz/votd)
