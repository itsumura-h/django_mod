#!/bin/bash -ex

if [ ! -d project ]; then
    git clone https://gitlab.com/dumblepy/django_mod.git
    mv django_mod/* . && rm -fr django_mod
elif [[ $1 = 'dev' ]]; then
    rm project/app/fixture/sample_users.json
    rm project/app/fixture/sample_posts.json
elif [[ $1 = 'test' ]]; then
    rm -fr project
    git clone https://gitlab.com/dumblepy/django_mod.git
    mv django_mod/* . && rm -fr django_mod
else
    git clone https://gitlab.com/dumblepy/django_mod.git
    mv django_mod/* . && rm -fr django_mod
fi

#=============================================================================================

python3 -m venv .venv
source .venv/bin/activate

pip3 install pipenv
pkg='django djangorestframework django-filter orator Jinja2'

mysqlflg='no'
testflg='no'
docflg='no'
jpflg='no'

while :
do
    echo 'Do you use Japanese? type y or n'
    read input

    case $input in
        y)
            jpflg='yes'
            break
            ;;
        n)
            break
            ;;
        *)
            echo 'type y or n'
            ;;
    esac
done

while :
do
    echo 'Do you use mysql? type y or n'
    read input

    case $input in
        y)
            pkg+=' pymysql'
            mysqlflg='yes'
            break
            ;;
        n)
            break
            ;;
        *)
            echo 'type y or n'
            ;;
    esac
done

while :
do
    echo 'Do you use test tool? type y or n'
    read input

    case $input in
        y)
            pkg+=' pytest faker'
            testflg='yes'
            break
            ;;
        n)
            rm -fr project/app/fixture
            break
            ;;
        *)
            echo 'type y or n'
            ;;
    esac
done

while :
do
    echo 'Do you use document support? type y or n'
    read input

    case $input in
        y)
            pkg+=' sphinx doc-cov'
            docflg='yes'
            break
            ;;
        n)
            rm -fr docs
            break
            ;;
        *)
            echo 'type y or n'
            ;;
    esac
done

#pipenv install pylint autopep8 django djangorestframework pymysql orator Jinja2 pytest faker eralchemy doc-cov
if [[ $1 = 'dev' ]]; then
    :
elif [[ $1 = 'test' ]]; then
    pipenv install $pkg
    pipenv install pylint autopep8 --dev
else
    pipenv install $pkg
    pipenv install pylint autopep8 --dev
fi

#=============================================================================================
# mysql
if [[ $1 = 'dev' ]] && [ $mysqlflg = 'yes' ]; then
    :
elif [[ $1 = 'test' ]] && [ $mysqlflg = 'yes' ]; then
    sed -i -e "4i import pymysql" project/manage.py
    sed -i -e "5i pymysql.install_as_MySQLdb()" project/manage.py
    sed -i -e "6i\ " project/manage.py
elif [ $mysqlflg = 'yes' ]; then
    sed -i -e "4i import pymysql" project/manage.py
    sed -i -e "5i pymysql.install_as_MySQLdb()" project/manage.py
    sed -i -e "6i\ " project/manage.py
fi

#=============================================================================================
# 日本語設定
if [ $jpflg = 'yes' ]; then
    sed -i -e "s?LANGUAGE_CODE = 'en-us'?LANGUAGE_CODE = 'ja'?g" project/project/settings.py
    sed -i -e "s?TIME_ZONE = 'UTC'?TIME_ZONE = 'Asia/Tokyo'?g" project/project/settings.py
    sed -i -e "s?fake = Faker()?fake = Faker('ja')?g" project/app/fixture/generator.py
fi

#=============================================================================================
# Migration
if [[ $1 = 'dev' ]] && [ ! -d project/db.sqlite3 ]; then
    python3 project/manage.py makemigrations
    python3 project/manage.py migrate
elif [[ $1 = 'test' ]]; then
    rm project/db.sqlite3
    python3 project/manage.py makemigrations
    python3 project/manage.py migrate
else
    python3 project/manage.py makemigrations
    python3 project/manage.py migrate
fi

#=============================================================================================

# pytestが存在するときだけ実行
if [ $testflg = 'yes' ]; then
    python3 project/app/fixture/generator.py
    python3 project/manage.py loaddata project/app/fixture/sample_users.json
    python3 project/manage.py loaddata project/app/fixture/sample_posts.json
else
    rm -fr project/app/fixture
fi

#=============================================================================================

# sphinxをセットアップ
if [[ $1 = 'dev' ]]; then
    :
elif [[ $1 = 'test' ]] && [ -d docs ]; then
    rm -fr docs
else
    :
fi

if [ ! -d docs ] && [ $docflg = 'yes' ]; then
    mkdir docs

    if [ $jpflg = 'yes' ]; then
sphinx-quickstart docs << EOF
y
_
project
Author
today
ja
.rst
index
y
y
n
y
y
n
n
n
y
n
y
n
EOF
    else
sphinx-quickstart docs << EOF
y
_
project
Author
today
en
.rst
index
y
y
n
y
y
n
n
n
y
n
y
n
EOF
    fi
fi
# Separate source and build directories (y/n) [n]:
# Name prefix for templates and static dir [_]:
# Project name:
# Author name(s):
# Project release []:
# Project language [en]:
# Source file suffix [.rst]: .rst or .txt
# Name of your master document (without suffix) [index]:
# autodoc: automatically insert docstrings from modules (y/n) [n]:
# doctest: automatically test code snippets in doctest blocks (y/n) [n]:
# intersphinx: link between Sphinx documentation of different projects (y/n) [n]:
# todo: write "todo" entries that can be shown or hidden on build (y/n) [n]:
# coverage: checks for documentation coverage (y/n) [n]:
# imgmath: include math, rendered as PNG or SVG images (y/n) [n]:
# mathjax: include math, rendered in the browser by MathJax (y/n) [n]:
# ifconfig: conditional inclusion of content based on config values (y/n) [n]:
# viewcode: include links to the source code of documented Python objects (y/n) [n]:
# githubpages: create .nojekyll file to publish the document on GitHub pages (y/n) [n]:
# Create Makefile? (y/n) [y]:
# Create Windows command file? (y/n) [y]:

#sphinx-apidoc -F -o docs/source/ project/ -s html
cd docs
make html
cd ../

#=============================================================================================
# .gitignoreをダウンロード

if [ ! -f .gitignore ]; then
    wget https://www.gitignore.io/api/python -O .gitignore
fi

#=============================================================================================

# .git削除 & git init
if [[ $1 = 'dev' ]]; then
    :
elif [[ $1 = 'test' ]]; then
    :
else
    if grep "Django_mod" README.md >/dev/null; then
        rm -fr .git
        git init

        # README.mdを綺麗サッパリ
        rm README.md
cat << EOF > README.md
your_project
===
EOF

        #自分自身を削除
        rm -- "$0"
    fi
fi
