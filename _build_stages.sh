#!/bin/bash

PRJ_NAME="python-prj-template"  # Change

check_res_and_popd_on_exit () {
  if [[ $? -ne 0 ]]; then
    echo "Something has utterly failed!"
    popd
    exit $?
  fi
}

create_venv () {
  VENV_PATH=`pwd`/venv
  echo "Creating venv"
  pushd src
  python -m venv ${VENV_PATH}
  check_res_and_popd_on_exit
  popd
}

set_version () {
  if [ "${PROGRAM_VERSION}" != "" ]; then
    echo "\nVERSION = \"${PROGRAM_VERSION}\"" >src/current_version.py
    cat puml_compiler/src/version.txt
  fi
}

activate_venv () {
  pushd src
  if [ "$OSTYPE" == "linux-gnu" ]; then
    echo "Linux venv activation"
    source ../venv/bin/activate
    PYSCRIPTS=`pwd`/../venv/bin
  else
    echo "Windows venv activation"

    # Check if activator.py is missing in Scripts
    if [ ! -f ../venv/Scripts/activator.py ]; then
      # Try to copy from Scripts/nt if it exists
      if [ -f ../venv/Scripts/nt/activator.py ]; then
        cp ../venv/Scripts/nt/activator.py ../venv/Scripts/
      else
        # Fallback: copy your custom activator
        cp ../utils/activator.py ../venv/Scripts/activator.py
      fi
    fi

    ../venv/Scripts/python ../venv/Scripts/activator.py
    popd
    PYSCRIPTS=`pwd`/venv/Scripts
  fi
}

install_requirements () {
  pushd .
  echo "Installing requirements"
  ${PYSCRIPTS}/pip install -r requirements.txt
  check_res_and_popd_on_exit
}

prepare_gettext() {
  pushd venv
  if [[ "$OSTYPE" == "win32" || "$OSTYPE" == "msys" ]]; then
    echo "Preparing gettext tools for Windows..."

    if [[ ! -f gettext.zip ]]; then
      echo "Downloading gettext tools..."
      curl -L -o gettext.zip https://github.com/vslavik/gettext-tools-windows/releases/download/v0.26/gettext-tools-windows-0.26.zip
      check_res_and_popd_on_exit
    else
      echo "gettext.zip already exists, skipping download."
    fi

    echo "Extracting gettext tools..."
    unzip -o -q gettext.zip -d gettext-bin
    check_res_and_popd_on_exit

    export PATH="$(pwd)/gettext-bin/bin:$PATH"
    echo "Gettext tools added to PATH"
  fi
  popd
}

build_msgs () {
  echo "Building message files"
  check_res_and_popd_on_exit
  pushd src
  xgettext -n -o locales/messages.pot main.py sample/sample.py && \
  msgmerge -N -U --backup=t locales/en_US/LC_MESSAGES/messages.po locales/messages.pot >locales/tmp_messages.pot && \
  msgfmt -o locales/en_US/LC_MESSAGES/messages.mo locales/en_US/LC_MESSAGES/messages.po && \
  msgmerge -N -U --backup=t locales/ru_RU/LC_MESSAGES/messages.po locales/messages.pot >locales/tmp_messages.pot && \
  msgfmt -o locales/ru_RU/LC_MESSAGES/messages.mo locales/ru_RU/LC_MESSAGES/messages.po
  check_res_and_popd_on_exit
  popd
}

run_tests () {
  echo "Running tests"
  pushd src/tests
  ${PYSCRIPTS}/python run_tests.py
  check_res_and_popd_on_exit
  popd
}

run_mypy () {
  echo "Running Mypy"
  pushd src
  ${PYSCRIPTS}/mypy --config-file mypy.ini .
  check_res_and_popd_on_exit
  popd
}

run_black() {
  echo "Reformatting the code with black"
  pushd src
  ${PYSCRIPTS}/black .
  check_res_and_popd_on_exit
  popd
}

run_linter() {
  echo "Linting with flake8"
  pushd src
  ${PYSCRIPTS}/flake8 .
  check_res_and_popd_on_exit
  popd
}

pyinstaller_build () {
  echo "Building a PyInstaller executable"
  S=':'
  if [[ "$OSTYPE" == "win32" || "$OSTYPE" == "msys" ]]; then
       S=';'
  fi
  mkdir out
  pushd src
  rm -rf ../out/distr/${PRJ_NAME}
  rm -rf ../out/temp
  ${PYSCRIPTS}/pyinstaller -F --paths . --add-data ./templates/template.xml${S}templates --add-data ./locales/en_US/LC_MESSAGES/messages.mo${S}locales/en_US/LC_MESSAGES --add-data ./locales/ru_RU/LC_MESSAGES/messages.mo${S}locales/ru_RU/LC_MESSAGES --noconfirm --distpath ../out/distr/${PRJ_NAME} -p . --workpath ../out/temp --clean ./main.py
  check_res_and_popd_on_exit
  popd
}
