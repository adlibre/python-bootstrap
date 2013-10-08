# Python Bootstrap

Easily create a Python virtual environment and deploy Python projects.

## Examples

To create a virtualenv _foo_ with the package _Django_ installed:

    curl --silent https://raw.github.com/adlibre/python-bootstrap/master/bootstrap.sh | bash -s foo Django

To create a virtualenv _tms_ with _Adlibre TMS_ installed from source:

    curl --silent https://raw.github.com/adlibre/python-bootstrap/master/bootstrap.sh | bash -s tms git+git://github.com/adlibre/Adlibre-TMS.git
