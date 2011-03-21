express = require('express')
sys = require('sys')
mongodb = require('mongodb')
redis_store = require('connect-redis')
_ = require('underscore')

oauth = require('./login')

app = express.createServer()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session({ secret : 'the mouse ran up the clock', store : new redis_store() })

app.register '.coffee', require('coffeekup')
app.set 'view engine', 'coffee'

app.get '/user', (req, res) ->
    oauth.request_token (error, oauth_token, oauth_token_secret, results) ->
        if error
            console.log 'oauth request_token error: ' + sys.inspect(error)
        else
            req.session.oauth = { token : oauth_token, token_secret : oauth_token_secret }
            res.redirect 'http://www.mendeley.com/oauth/authorize/?oauth_token=' + oauth_token + '&oauth_callback=oob'

app.get '/userlogin/:verifier', (req, res) ->
    verifier = req.params.verifier

    oauth.access_token req.session.oauth.token, \
                        req.session.oauth.token_secret, \
                        verifier, \
                        (error, oauth_access_token, oauth_access_token_secret, results) ->
        if error
            console.log 'oauth access_token error: ' + sys.inspect(error)
        else
            req.session.oauth.access_token = oauth_access_token
            req.session.oauth.access_token_secret = oauth_access_token_secret
            res.redirect '/library'

app.get '/library', (req, res) ->
    oauth.get_protected 'http://www.mendeley.com/oapi/library/', \
                        'get', \
                        req.session.oauth.access_token, \
                        req.session.oauth.access_token_secret, \
                        (error, data, response) ->
        libdata = JSON.parse(data)
        detailed = []
        _.each libdata.document_ids, (id) ->
            url = 'http://www.mendeley.com/oapi/library/documents/' + id + '/'
            oauth.get_protected url, \
                                'get', \
                                req.session.oauth.access_token, \
                                req.session.oauth.access_token_secret, \
                                (error, data, response) ->
                if error
                    console.log error
                else
                    details = JSON.parse(data)
                    console.log details
                    detailed.push(details.title)
                    if detailed.length == libdata.document_ids.length
                        res.render 'library', context: { library : detailed }
app.listen(20008)
console.log 'WTR server started on port %s', app.address().port

