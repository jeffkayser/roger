#!/bin/bash

##############################################################################
##
## Roger, the quick webapp skeleton generator
##
##############################################################################


ROGHEAD="💀  ◅("
ALLOWED_CHARS='0-9a-zA-Z_-'
PROJECT="$1"
if [ -z "$PROJECT" ]; then
    echo "${ROGHEAD} Enter the project's name as the first argument"
    exit 1
fi
PROJECT_CHECK=$(tr -d ${ALLOWED_CHARS} <<<$PROJECT)
if [ ! -z "$PROJECT_CHECK" ]; then
    echo "${ROGHEAD} Project name can only contain the following characters: ${ALLOWED_CHARS}"
    exit 1
fi
PYTHON_BIN="$2"
: ${PYTHON_BIN:="`which python`"}

PARENT_DIR=`pwd`
BASE_DIR="$PARENT_DIR/$PROJECT"
APP_DIR="$BASE_DIR/app"
STATIC_DIR="$APP_DIR/static"
TEMPLATE_DIR="$APP_DIR/templates"
TEMPLATE_BASE_FILENAME="base.html"
BASE_CSS_FILENAME="base.css"
APP_FILENAME="app.py"
APP_PATH="${APP_DIR}/${APP_FILENAME}"
APP_HOST='0.0.0.0'
APP_PORT=5005


# Setup directory
mkdir -p $PROJECT
cd $BASE_DIR

# Python environment
VENV_DIR="$WORKON_HOME"
: ${VENV_DIR:="venv"}
if [ ! -d "$VENV_DIR" ]; then
    mkdir -p $VENV_DIR
fi
VENV_DIR="$VENV_DIR/$PROJECT"
virtualenv --no-site-packages -p "${PYTHON_BIN}" "$VENV_DIR"
if [ $? -ne 0 ]; then
    echo "${ROGHEAD} Failed to build virtualenv. Check that you've configured virtualenv and virtualenvwrapper properly."
    exit 1
fi
echo "${ROGHEAD} Installed virtualenv to '${VIRTUAL_ENV}'"
. "${VENV_DIR}/bin/activate"
if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "${ROGHEAD} Failed to activate virtualenv."
    exit 1
fi
pip install --upgrade pip
touch requirements.txt
echo "flask" >> requirements.txt
pip install -r requirements.txt
mkdir -p $APP_DIR
mkdir -p $TEMPLATE_DIR
mkdir -p $STATIC_DIR/css
mkdir -p $STATIC_DIR/js
mkdir -p $STATIC_DIR/fonts
mkdir -p $STATIC_DIR/img

# Bootstrap/jQuery
cd $BASE_DIR
#bower init
bower install 'bootstrap#v4.0.0-alpha.2' --save
cd $STATIC_DIR/css
ln -s ../../../bower_components/bootstrap/dist/css/* ./
cd $STATIC_DIR/js
ln -s ../../../bower_components/bootstrap/dist/js/* ./
ln -s ../../../bower_components/jquery/dist/* ./
echo "${ROGHEAD} Installed jQuery and Bootstrap"

# Font Awesome
cd $BASE_DIR
bower install fontawesome --save
cd $STATIC_DIR/css
ln -s ../../../bower_components/font-awesome/css/* ./
cd $STATIC_DIR/fonts
ln -s ../../../bower_components/font-awesome/fonts/* ./
echo "${ROGHEAD} Installed Font Awesome"

# Build sample files
# base.css
echo "body { font-family: sans-serif; }" > "$STATIC_DIR/css/$BASE_CSS_FILENAME"
# base.html
read -d '' BASE_CODE <<- EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <link rel="stylesheet" href="{{ url_for('.static', filename='css/bootstrap.min.css') }}">
    <link rel="stylesheet" href="{{ url_for('.static', filename='css/font-awesome.min.css') }}">
    <link rel="stylesheet" href="{{ url_for('.static', filename='css/${BASE_CSS_FILENAME}') }}">
    <title></title>
  </head>
  <body>
    <script src="{{ url_for('.static', filename='js/jquery.min.js') }}"></script>
    {#<script src="{{ url_for('.static', filename='js/tether.min.js') }}"></script>#}
    <script src="{{ url_for('.static', filename='js/bootstrap.min.js') }}"></script>
  </body>
</html>
EOF
echo "$BASE_CODE" > "$TEMPLATE_DIR/$TEMPLATE_BASE_FILENAME"
# app.py
read -d '' APP_CODE <<- EOF
#!/usr/bin/env python
# -=- coding: utf-8 -=-

from flask import Flask


app = Flask(__name__)


@app.route('/')
def root():
    return ('<!DOCTYPE html><html><head><meta charset="utf-8"></head>'
            '<body style="color: #eee; background: #111;">'
            '<h1 style="text-align: center;">💀<br>Arr matey!</h1></body></html>')


if __name__ == '__main__':
    app.run(host='${APP_HOST}', port=${APP_PORT}, debug=True)
EOF
echo "$APP_CODE" > "$APP_PATH"
chmod +x "$APP_PATH"
if [ -z "$WORKON_HOME" ]; then
    VENV_CMD="source ${VENV_DIR}/bin/activate"
else
    VENV_CMD="workon ${PROJECT}"
fi
echo "${ROGHEAD} Created base Flask application (execute \"${VENV_CMD} && python ${APP_PATH}\" to run it)"

# Source control
cd $BASE_DIR
touch README.md
git init .
read -d '' GITIGNORE <<- EOF
bower_components/
*.iml
.idea/
*.swp
EOF
echo "$GITIGNORE" > "$BASE_DIR/.gitignore"
git add .
git status
echo "${ROGHEAD} Review the staged files, then execute \"git commit -m 'First commit'\""

cd "$BASE_DIR"

exit 0
