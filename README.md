# gpg.mozilla.org SKS Keyserver

This is the setup for the SKS keyserver running at https://gpg.mozilla.org
It runs the [SKS Keyserver](https://bitbucket.org/skskeyserver/sks-keyserver/wiki/Home) software

## Volume (persistent data)

Due to how SKS works, the whole `/var/sks` directory is mounted as a persistent volume.
This includes the configuration, key database, web site, logs, etc.

## Docker files

### sks-db

`sks-db` is the database server for SKS. It also listens on TCP port `11371` and exposes a web-server on that port
(serving [sks-db/etc/web](sks-db/etc/web).

### sks-recon
`sks-recon` is the recon(aissance) server for SKS, which sync with other SKS peers. It listens on TCP port `11370` for
other recon servers to contact and transfer data with.

### sks-cron
`sks-cron` simply run cron style tasks for SKS such as log rotation and database vacuuming.

## Web server

Note that there is currently no "real" web-server included with this repository at this time.
Serving directly from `sks-db` is not recommended and you should front it with your choice of load-balancer (nginx,
apache, AWS ELB, you name it)


## Building

Type `make build`.

To build individual docker files, simply go to the right directory and type `make`.

## First time use

For the first time use you'll probably want to establish a database with all (or most) PGP known-keys. This database is
several Gb in size and you'll want to import for a database dump. You can find sources on the [SKS
website](https://bitbucket.org/skskeyserver/sks-keyserver/wiki/KeydumpSources)

Convenience functions are also provided here: `make install` will automatically grab, decompress the dump and import it
for you. You can change the default sources as such: `DUMP_URL=https://example.net/dump make install`

Note that all configuration, database and website go to the `sks` volume and thus, if you need to start from scratch,
you'll want to delete that volume.

Finally, make sure you configure as per the [SKS Documentation](https://bitbucket.org/skskeyserver/sks-keyserver/wiki/)
and change [sks-db/etc/](sks-db/etc/) files such as `sksconf`, `membership`, etc. to your liking.

## Website update

A convenience function is provided to update the website on the volume: 
- edit [sks-db/etc/web/](sks-db/etc/web/)
- type `make update-web`

## Containers update

Type `make rebuild`.

## Run everything in docker-compose

Type `make`.
