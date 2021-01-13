export FLASK_APP=autoapp.py && flask run
export FLASK_APP=autoapp.py && flask run --host 0.0.0.0
export FLASK_APP=autoapp.py && flask test

###fill db with test images (colors)
export FLASK_APP=autoapp.py && flask driver

brew install libmagic # for mimetype guessing
