DUMP_URL := "http://keys.niif.hu/keydump/"
VOLUME := "gpgmozillaorg_sks"

all: build

run: docker-compose.yml cleanup
	docker-compose -f docker-compose.yml up

kill: docker-compose.yml
	docker-compose -f docker-compose.yml down

cleanup:
	@echo Removing old unix sockets...
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 gpgmozillaorg_sks-db \
	    rm -f /var/sks/recon_com_sock && rm -f /var/sks/db_com_sock

build: */Dockerfile
	docker-compose -f docker-compose.yml build

rebuild:
	@echo Rebuilding/updating images
	docker-compose -f docker-compose.yml build --pull --no-cache

install:
	@echo ensuring docker volume is present
	docker volume create sks
	@echo Setting permissions
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 gpgmozillaorg_sks-db chown -R sks:sks /var/sks

	@echo "Getting dump from $(DUMP_URL) (see sources at https://bitbucket.org/skskeyserver/sks-keyserver/wiki/KeydumpSources)"
	@echo This will take forever. How much coffee can you drink before it\'s done? tic-tac-tic-tac...
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 -w /var/sks/dump gpgmozillaorg_sks-db \
		wget -crp -e robots=off -l1 --no-parent --cut-dirs=3 -nH -A pgp,bz2,gz,xz,txt $(DUMP_URL)

	@echo Decompressing files...
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 -w /var/sks/dump gpgmozillaorg_sks-db \
	        bzip2 -d \*bz2

	@echo Creating KDB...
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 -w /var/sks/ gpgmozillaorg_sks-db \
                sks build
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 -w /var/sks/ gpgmozillaorg_sks-db \
                sh -c 'sks merge dump/*pgp'

	@echo Creating PTree...
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 -w /var/sks/ gpgmozillaorg_sks-db \
	    	sks pbuild
	@echo Fixing permissions for $(VOLUME)
	docker run -ti --mount source=$(VOLUME),target=/var/sks -u 0 -w /var/sks/ gpgmozillaorg_sks-db \
                chown -R sks:sks /var/sks

update-web:
	docker run -ti --mount source=$(VOLUME),target=/var/sks -w /var/sks/ --name gpgmozillaorg_tmp gpgmozillaorg_sks-db true
	docker cp sks-db/etc/web/. gpgmozillaorg_tmp:/var/sks/web/
	docker rm gpgmozillaorg_tmp

.PHONY: all
