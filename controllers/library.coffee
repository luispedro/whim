async = require('async')
_ = require('underscore')
sys = require('sys')

oauth = require('../login')
models = require('../models')
simple = require('./simple').simple

retrieve_doi_information_mendeley = (doi, title, cb) ->
    url = 'oapi/documents/details/' + doi.replace('/', '%252F') + '?type=doi'
    oauth.get_protected url, \
            null, \
            null, \
            (error, data, response) ->
                if error
                    response = error.statusCode
                    uuid = null
                    if not (response == 404 or response == 403)
                        cb error, null
                        return
                else
                    response = 200
                    docdata = JSON.parse(data)
                    title = docdata.title
                    uuid = docdata.uuid
                doc = new models.Document(
                                { doi: doi
                                , title: title
                                , uuid: uuid
                                , queried_at: new Date()
                                , response: response
                                })
                cb null, doc

retrieve_doi_information = (doi, title, cb) ->
    models.Document.findOne { doi: doi }, (err, doc) ->
        if err
            console.log "[doi lookup] mongo error: "+err
        if err or doc is null
            console.log "[doi lookup] will query mendeley"
            retrieve_doi_information_mendeley doi, title, cb
        else
            console.log "[doi lookup] found it in mongodb"
            cb null, doc

retrieve_library_mendeley = (req, cb) ->
    nr_items = 1000 unless process.env.NODE_ENV == 'development'
    oauth.get_protected "oapi/library/?items=#{nr_items}", \
                        req.session.oauth.access_token, \
                        req.session.oauth.access_token_secret, \
                        (error, data, response) ->
        libdata = JSON.parse(data)
        library = new models.Library()
        library.user = req.session.user._id

        id_to_doc = (id, cb) ->
            url = 'oapi/library/documents/' + id + '/'
            oauth.get_protected url, \
                                req.session.oauth.access_token, \
                                req.session.oauth.access_token_secret, \
                                (error, data, response) ->

                if error
                    cb error, null
                else
                    details = JSON.parse(data)
                    if details.identifiers.doi?
                        retrieve_doi_information details.identifiers.doi, details.title, cb
                    else
                        cb null, new models.Document({ title: details.title, doi: null, uuid: null })
        async.map libdata.document_ids, id_to_doc, (err, docs) ->
            if err
                cb err, null
            else
                cb null, docs
                get_doc_id = (doc, cb) ->
                    if not doc.isNew # We should also check whether doc.modified, calling doc.modified was crashing
                        cb null, doc._id
                    else
                        doc.save (err) ->
                            if err
                                console.log "Error in mongoose (saving document): "+err
                                cb err, null
                            else
                                cb null, doc._id
                async.map docs, get_doc_id, (err, ids) ->
                    if err
                        console.log "Error in mongoose (saving docs): "+err
                    else
                        library.documents = ids
                        library.save (err) ->
                            if err
                                console.log "Error in mongoose (saving library): "+err

@retrieve_library = (req, cb) ->
    models.Library.findOne { user: req.session.user._id }, (err, library) ->
        if err
            cb err, null
        else if library?
            console.log "[retrieve library] found library in mongodb"
            objectid_to_doc = (id, cb) ->
                models.Document.findById id, (err, doc) ->
                    if err
                        cb err, null
                    else
                        if not doc?
                            console.log "[mongoose doc lookup] null return for "+id
                        cb null, doc
            async.map library.documents, objectid_to_doc, cb
        else
            retrieve_library_mendeley req, cb

show = (req, res) ->
    if not req.session.oauth
        res.redirect '/user'
        return
    exports.retrieve_library req, (err, documents) ->
        if err
            console.log '[retrieve library] error: '+sys.inspect(err)
        else
            console.log '[retrieve library] success'
            counter = (acc, doc) ->
                if doc.uuid?
                    acc + 1
                else
                    acc
            nr_uuids = _.reduce documents, counter, 0
            console.log '[retrieve library] success ('+nr_uuids+')'
            res.render 'library', context: { documents: documents, nr_uuids: nr_uuids }

ready = (req, res) ->
    if req.session.library_ready
        res.write '{ "available" : true }'
    else
        res.write '{ "available" : false }'
    res.end()

show_delayed = (req, res) ->
    session = req.session
    res.render 'library_delayed'
    session.library_ready = false
    exports.retrieve_library req, ->
        session.library_ready = true
        console.log "[library ready]"
        session.save()


@register_urls = (app) ->
    app.namespace '/library', ->
        app.get '/ready', ready
        app.get '/show', show
        app.get '/show-delayed', show_delayed
