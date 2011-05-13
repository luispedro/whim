_ = require 'underscore'

models = require '../models'

details = (req, res) ->
    uuid = req.query.uuid
    if not uuid?
        res.render 'error', error: 'Missing UUID argument'
        return
    models.Document.findOne { uuid: uuid }, (err, doc) ->
        if err
            res.render 'error', error: err
        else if not doc?
            res.render 'error', error: "Document corresponding to #{uuid} not found."
        else
            res.render 'documents/details', doc: doc

@register_urls = (app) ->
    app.namespace '/documents', ->
        app.get '/details', details
