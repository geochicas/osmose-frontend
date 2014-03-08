#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
# Copyright 2012 Frederic Rodrigo
#
#

import bottle
from bottle import route, view, template, error

from tools import utils

app = bottle.default_app()

for l in utils.allowed_languages:
    app.mount('/' + l, app)

from bottle import SimpleTemplate
SimpleTemplate.defaults["get_url"] = app.get_url

import bottle_pgsql
app.install(bottle_pgsql.Plugin("dbname='%s' user='%s' password='%s'" % (utils.pg_base, utils.pg_user, utils.pg_pass), dictrows=False))
import bottle_gettext, os
app.install(bottle_gettext.Plugin('osmose-frontend', os.path.join("po", "mo"), utils.allowed_languages))

def ext_filter(config):
    regexp = r'html|json|xml|rss|png|svg|pdf'
    def to_python(match):
        return match if match in ('html', 'json', 'xml', 'rss', 'png', 'svg', 'pdf') else 'html'
    def to_url(ext):
        return ext
    return regexp, to_python, to_url
app.router.add_filter('ext', ext_filter)

@route('/', name='root')
def index(lang):
    translate = utils.translator(lang)
    return template('index')

@route('/contact')
def contact(lang, name=None):
    translate = utils.translator(lang)
    return template('contact')

@route('/copyright')
def copyright(lang, name=None):
    translate = utils.translator(lang)
    return template('copyright')

@route('/translation')
def translation(lang, name=None):
    translate = utils.translator(lang)
    return template('translation')

@error(404)
@view('404')
def error404(error):
    return {}

import api_0_1
import api_0_2_meta
import byuser
import control
import error
import errors
import map
import false_positive

@route('/<filename:path>', name='static')
def static(filename):
    return bottle.static_file(filename, root='static')
