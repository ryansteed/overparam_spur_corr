all: clean install celebA cub
.PHONY: all install clean data

data: celebA cub

install:
	pip install -r requirements.txt
	echo "Don't forget to change the root directory in data/data.py."

clean:
	-rm -rf celebA cub

celebA:
	pip install kaggle
	mkdir ~/.kaggle || echo Warning: could not create kaggle token dir, make sure ~/.kaggle already exists.
	cp kaggle.json ~/.kaggle
	chmod 600 ~/.kaggle/kaggle.json
	kaggle datasets download -d 'jessicali9530/celeba-dataset'
	mkdir celebA
	unzip celeba-dataset.zip -d celebA/data
	rm celeba-dataset.zip
	cd celebA/data
	mv celebA/data/img_align_celeba/img_align_celeba celebA/data/img_align_celeba-b && rm -rf celebA/data/img_align_celeba && mv celebA/data/img_align_celeba-b celebA/data/img_align_celeba

cub:
	curl http://downloads.cs.stanford.edu/nlp/data/dro/waterbird_complete95_forest2water2.tar.gz \
		--output waterbird_complete95_forest2water2.tar.gz
	tar -xvf waterbird_complete95_forest2water2.tar.gz
	rm waterbird_complete95_forest2water2.tar.gz
	mkdir cub
	mv waterbird_complete95_forest2water2 cub
