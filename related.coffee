_ = require('underscore')

oauth = require('./login')
models = require('./models')

retrieve_related = (uuid, cb) ->
    console.log "will query mongodb"
    models.Related.findOne { base: uuid }, (err, docs) ->
        if err or docs is null
            console.log "querying mendeley"
            url = 'http://api.mendeley.com/oapi/documents/related/'+uuid+'/'
            oauth.get_protected url, \
                null, \
                null, \
                (error, data, response) ->
                    if error
                        console.log "mendeley error"
                        cb error, null
                    else
                        details = JSON.parse(data)
                        console.log "retrieved from mendeley"
                        cb null, details.documents
                        related = new models.Related
                        related.base = uuid
                        related.related = []
                        _.each details.document, (r) -> related.related.push r.uuid
                        related.save()
        else
            console.log "lookup on mongodb"
            documents = _.map docs.related, (d) -> { title: d }
            cb null, documents

@related = (req, res) ->
    uuid = req.query.uuid
    if not uuid?
        res.render 'error', context: { msg : 'missing argument' }
        return
    console.log "will retrieve uuid"
    retrieve_related uuid, (error, related) ->
        res.render 'related', context: { title: "My title", related: related }
