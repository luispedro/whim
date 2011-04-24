_ = require('underscore')
async = require('async')
sys = require('sys')

oauth = require('./login')
models = require('./models')

@retrieve_related_by_uuid = (uuid, cb) ->
    console.log "[related] will query mongodb"
    models.Related.findOne { base: uuid }, (err, docs) ->
        if err or docs is null
            console.log "querying mendeley"
            url = 'oapi/documents/related/'+uuid+'/'
            oauth.get_protected url, \
                null, \
                null, \
                (error, data, response) ->
                    if error
                        console.log "mendeley error"
                        cb error, null
                    else
                        details = JSON.parse(data)
                        console.log "[related] retrieved from mendeley"
                        cb null, details.documents
                        related = new models.Related()
                        related.base = uuid
                        related.related = []
                        _.each details.documents, (r) -> related.related.push r.uuid
                        related.save (err) ->
                            if err
                                console.log "[error saving related]: "+sys.inspect(err)
                        save_doc = (document, cb) ->
                            models.Document.findOne { uuid: document.uuid }, (err,doc) ->
                                if err
                                    cb err
                                else if not doc?
                                    doc = new models.Document(
                                                    { doi: document.doi
                                                    , title: document.title
                                                    , uuid: document.uuid
                                                    , queried_at: new Date()
                                                    })
                                    doc.save cb
                        async.forEach details.documents, save_doc, (err) ->
                            if err
                                console.log "[error saving related documents]: "+sys.inspect(err)

        else
            console.log "[related] lookup on mongodb (result: "+docs.base+" -> "+docs.related.length+")"
            lookup_doc = (uuid, cb) -> models.Document.findOne { uuid: uuid }, cb
            async.map docs.related, lookup_doc, cb

@retrieve_related = (doc, cb) ->
    if doc.uuid?
        exports.retrieve_related_by_uuid doc.uuid, cb
    else
        cb 'related.retrieve_related: uuid is needed', null

@related = (req, res) ->
    uuid = req.query.uuid
    if not uuid?
        res.render 'error', context: { msg : 'missing argument' }
        return
    console.log "will retrieve uuid"
    exports.retrieve_related_by_uuid uuid, (error, related) ->
        res.render 'related', context: { title: "My title", related: related }

