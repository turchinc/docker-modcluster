# Content

* Ubuntu Xenial
* Apache 2.4
* mod_cluster 1.3.1

# Build

	docker build -t turchinc/xenial-modcluster .

# Run

	docker run -p 80:80 -d turchinc/xenial-modcluster
