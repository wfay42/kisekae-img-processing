## Makefile for producing model images
IMAGE_SCRIPT = ./doit.sh

default: images

# create images and copy into destination folder
images:
	$(IMAGE_SCRIPT) -f

# create images, but do not copy
images_local:
	$(IMAGE_SCRIPT)
