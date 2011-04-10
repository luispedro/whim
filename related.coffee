oauth = require('./login')
models = require('./models')

@related = (req, res) ->
    uuid = req.query.uuid
    if not uuid?
        res.render 'error', context: { msg : 'missing argument' }
        return
    url = 'http://api.mendeley.com/oapi/documents/related/'+uuid+'/'
    oauth.get_protected url, \
            null, \
            null, \
            (error, data, response) ->
                if error
                    console.log error
                else
                    details = JSON.parse(data)
                    res.render 'related', context: { title : "My title", related : details.documents }
