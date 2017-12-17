export DJANGO_SETTINGS_MODULE = tests.settings
export PYTHONPATH := $(shell pwd)

test:
	pip install -r tests/requirements.txt
	flake8 --ignore=W801,E128,E501,W402 django_js_reverse --exclude=django_js_reverse/rjsmin.py
	coverage erase
	tox
	coverage combine
	coverage report
	coverage erase

release:
	git checkout master
	git merge develop -m "bump v$(VERSION)"
	git push origin master
	git tag v$(VERSION)
	git push origin v$(VERSION)
	pip install wheel
	python setup.py sdist bdist_wheel upload --sign --identity=99C3C059
	git checkout develop

optimizing_imports:
	pip install -r tests/requirements.txt
	isort -rc *.py
	isort -rc tests/
	isort -rc django_js_reverse/

clean:
	rm -rf build dist django_js_reverse.egg-info
