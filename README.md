Django_mod
===

これはdjango-rest-framework, Orator, Jinja2を含んだDjangoのプロジェクトを自動生成するスクリプトです。

## 使い方
Pythonを使えるようにして、setup.pyを実行するだけでOK！
```
python -V
> 3.6.8

bash setup.sh
```

対話型の質問が4回聞かれます。日本語を使うかどうか、mysqlを使うかどうか、テストツールを使うかどうか、ドキュメントサポートを使うかどうか。  
全てにyesで回答する場合は、yesのオプションをつけてコマンドを実行しましょう

```
yes | bash setup.sh
```

mysqlを使うと答えた場合は、pymysqlが、
テストツールを使うと答えた場合は、pytestとfakerが
ドキュメントサポートを使うと答えた場合はsphinxとdoc-covが追加でインストールされます。

[pymysql](https://github.com/PyMySQL/PyMySQL)  
[pytest](https://docs.pytest.org/en/latest/)  
[faker](https://github.com/joke2k/faker)  
[sphinx](http://www.sphinx-doc.org/ja/stable/index.html)  
[doc-cov](http://cocodrips.hateblo.jp/entry/2019/02/06/234630)

## !!注意!!
なお、このバッチとREADME.mdは実行後自動的に消滅する。

---

Auto generating script of Django project with django-rest-framework, Orator, Jinja2

## How to use?
All you need is just making Python available and run following command
```
python -V
> 3.6.8

bash setup.sh
```

After that, you will be asked questions 4 times. whether use Japanese or not, whether use mysql or not, whether use test tool or not, whether use document support or not.
If you want to say YES for all, you can run command with yes option as following

```
yes | bash setup.sh
```
If you use mysql, pymysql is going to be installed.  
If you use test tool, pytest and faker are going to be installed.  
If you use document support, sphinx and doc-cov are going to be installed.

## Django-Rest-Framework
https://www.django-rest-framework.org

DRF is a useful tool to develop API

## Orator
https://orator-orm.com

Orator is an Active Record ORM which is influenced by Laravel ORM

## Jinja2
http://jinja.pocoo.org/docs/2.10/

Jinja2 is more useful template engin than default Django template system

[pymysql](https://github.com/PyMySQL/PyMySQL)  
[pytest](https://docs.pytest.org/en/latest/)  
[faker](https://github.com/joke2k/faker)  
[sphinx](http://www.sphinx-doc.org/en/stable/index.html)  
[doc-cov](https://pypi.org/project/doc-cov/)

## !!Caution!!
This shell and README.md will self-destruct after run setup.
