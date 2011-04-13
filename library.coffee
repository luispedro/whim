async = require('async')

oauth = require('./login')
models = require('./models')

retrieve_doi_information = (doi, title, cb) ->
    doi = doi.replace('/', '%252F')
    url = 'http://www.mendeley.com/oapi/documents/details/' + doi + '?type=doi'
    oauth.get_protected url, \
            null, \
            null, \
            (error, data, response) ->
        if error
            if error.statusCode == 404
                cb null, { title: title }
            else
                cb error, null
        else
            docdata = JSON.parse(data)
            doc = { doi: doi, title: docdata.title, uuid: docdata.uuid }
            cb null, doc
            doc = new models.Document(doc)
            doc.save (err) ->
                if err
                    console.log "Error in mongoose (saving document): "+err
    

@handle_library = (req, res) ->
    oauth.get_protected 'http://www.mendeley.com/oapi/library/', \
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
            res.render 'library', context: { library: docs }
            library.save (err) ->
                if err
                    console.log "Error in mongoose (saving library): "+err

