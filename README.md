# Content

* Debian Jessie
* Apache 2.4
* mod_cluster 1.2.9

# Build

	docker build -t sewatech/modcluster .

# Run

	docker run -p 80:80 -d sewatech/modcluster
