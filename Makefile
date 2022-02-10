
## Pandoc: Use custom docker image "alpine-pandoc-hugo"
## To build use "make docker"
DOCKER_IMAGE      = alpine-pandoc-hugo
DOCKER_COMMAND    = docker run --rm -i
DOCKER_USER       = -u "$(shell id -u):$(shell id -g)"
DOCKER_VOLUME     = -v "$(shell pwd):/data" -w "/data"

PANDOC = $(DOCKER_COMMAND) $(DOCKER_VOLUME) $(DOCKER_USER) --entrypoint="pandoc" $(DOCKER_IMAGE)


## Data-Dir: Path to the Git submodule of Pandoc-Lecture
## Resource-Path: Where to search for bib files and other resources?
PANDOC_DIRS = --data-dir=.pandoc --resource-path=".:.pandoc"


## Make everything
.PHONY: all
all: slides


## Make slides
.PHONY: slides
slides: slides.pdf


## Build actual slide set (PDF)
slides.pdf: slides.md
	$(PANDOC) $(PANDOC_DIRS) -d slides $< -o $@


## Build Docker image "alpine-pandoc-hugo"
.PHONY: docker
docker:
	cd .github/actions/alpine-pandoc-hugo && make clean all


## Clean up
.PHONY: clean
clean:
	rm -rf slides.pdf
