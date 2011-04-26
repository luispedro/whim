async = require('async')
_ = require('underscore')
sys = require('sys')

models = require('../models')
library = require('./library')
related = require('../related')

retrieve_recommendations = (req, cb) ->
    maybe_retrieve = (doc, cb) ->
        if doc.uuid?
            related.retrieve_related doc, cb
        else
            console.log '[maybe_retrive] skipping'
            cb null, []
    library.retrieve_library req, (err, documents) ->
        async.map documents, maybe_retrieve, (err, related) ->
            if err
                cb err, null
            else
                cb null, _.flatten related

show = (req, res) ->
    retrieve_recommendations req, (err, documents) ->
        if err
            console.log '[retrieve recommendations] error: '+sys.inspect(err)
            res.render 'error', context: { error: sys.inspect(err) }
        else
            console.log '[retrieve recommendations] success ('+documents.length+' documents)'
            todisplay = {}
            _.each documents, (doc) ->
                if doc.uuid of todisplay
                    ++todisplay[doc.uuid].hits
                else
                    todisplay[doc.uuid] =
                        doc: doc
                        hits: 1
            todisplay = (todisplay[d] for d in Object.keys(todisplay))
            todisplay.sort (d0, d1) ->
                d1.hits - d0.hits
            res.render 'recommended', context: { documents: todisplay }

ready = (req, res) ->
    if req.session.recommended_ready
        res.write '{ "available" : true }'
    else
        res.write '{ "available" : false }'
    res.end()

show_delayed = (req, res) ->
    session = req.session
    res.render 'recommended_delayed'
    session.recommended_ready  = false
    retrieve_recommendations req, ->
        session.recommended_ready = true
        session.save()


@register_urls = (app) ->
    app.namespace '/recommended', ->
        app.get '/ready', ready
        app.get '/show', show
        app.get '/show-delayed', show_delayed
