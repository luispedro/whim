_ = require 'underscore'
sys = require 'sys'

models = require '../models'
mendeley = require '../mendeley'
users = require './users'

uuid_required = (handler) -> (req, res) ->
    uuid = req.query.uuid
    if not uuid?
        res.render 'error', error: 'missing UUID argument'
    else
        handler req, res, uuid

details = uuid_required (req, res, uuid) ->
    models.Document.findOne { uuid: uuid }, (err, doc) ->
        if err
            res.render 'error', error: err
        else if not doc?
            res.render 'error', error: "Document corresponding to #{uuid} not found."
        else
            res.render 'documents/details', doc: doc

add = users.login_required uuid_required (req, res, uuid) ->
    mendeley.get_protected "oapi/documents/details/#{uuid}/", \
        null, \
        null, \
        (err, data, response) ->
            document_in = JSON.parse data
            document = {}
            for k in ['title', 'authors', 'pages', 'type', 'year', 'website', 'keywords']
                document[k] = document_in[k]
            req = mendeley.post 'oapi/library/documents/', \
                        req.session.oauth.access_token, \
                        req.session.oauth.access_token_secret, \
                        { document: JSON.stringify document }, \
                        (err, data, response) ->
                if err and err.statusCode >= 400
                    res.render 'error', error: err
                else
                    res.render 'documents/added'

@register_urls = (app) ->
    app.namespace '/documents', ->
        app.get '/details', details
        app.get '/add', add
