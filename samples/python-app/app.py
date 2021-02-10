from flask import Flask, Response
import os
import sys
import traceback
import json
import yaml
import logging

application = Flask(__name__)

def root_dir():  # pragma: no cover
    return os.path.abspath(os.path.dirname(__file__))

def get_file(filename):  # pragma: no cover
    try:
        src = os.path.join(root_dir(), filename)
        return open(src).read()
    except IOError as exc:
        return str(exc)

@application.route("/")
def test_page():
    content = get_file('index.html')
    return Response(content, mimetype="text/html")

if __name__ == "__main__":
    application.run(port=8080, host="0.0.0.0")
