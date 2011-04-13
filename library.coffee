async = require('async')
_ = require('underscore')

oauth = require('./login')
models = require('./models')


retrieve_doi_information_mendeley = (doi, title, cb) ->
    url = 'http://www.mendeley.com/oapi/documents/details/' + doi.replace('/', '%252F') + '?type=doi'
    oauth.get_protected url, \
            null, \
            null, \
            (error, data, response) ->
                if error and error.statusCode != 404
                        cb error, null
                else
                    if error and error.statusCode == 404
                        uuid = null
                    else
                        docdata = JSON.parse(data)
                        title = docdata.title
                        uuid = docdata.uuid
                    doc = new models.Document({ doi: doi, title: title, uuid: uuid })
                    cb null, doc
                    doc.save (err) ->
                        if err
                            console.log "Error in mongoose (saving document): "+err

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

@handle_library = (req, res) ->
    oauth.get_protected 'http://www.mendeley.com/oapi/library/?items=1000', \
                        req.session.oauth.access_token, \
                        req.session.oauth.access_token_secret, \
                        (error, data, response) ->
        libdata = JSON.parse(data)
        library = new models.Library()
        library.username = req.session.username
        library.documents = []

        id_to_doc = (id, cb) ->
            url = 'http://www.mendeley.com/oapi/library/documents/' + id + '/'
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
                        cb null, { title: details.title }
        async.map libdata.document_ids, id_to_doc, (err, docs) ->
            counter = (acc, doc) ->
                if doc.uuid?
                    return acc
                return acc + 1
            nr_uuids = _.reduce docs, counter, 0
            res.render 'library', context: { library: docs, nr_uuids: nr_uuids }
            library.documents = docs
            library.save (err) ->
                if err
                    console.log "Error in mongoose (saving library): "+err

