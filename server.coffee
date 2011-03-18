express = require('express')
sys = require('sys')
oauth = require('./login')

app = express.createServer()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session({ secret : 'the mouse ran up the clock' })

app.get '/user', (req, res) ->
    oauth.request_token (error, oauth_token, oauth_token_secret, results) ->
        if error
            console.log 'oauth request_token error: ' + sys.inspect(error)
        else
            req.session.oauth = { token : oauth_token, token_secret : oauth_token_secret }
            res.redirect 'http://www.mendeley.com/oauth/authorize/?oauth_token=' + oauth_token + '&oauth_callback=oob'

app.get '/userlogin/:verifier', (req, res) ->
    verifier = req.params.verifier

    console.log 'token:' + req.session.oauth.token
    console.log 'secret:' + req.session.oauth.token_secret
    console.log 'verifier:' + verifier
    console.log 'typeof verifier:' + typeof verifier
    oauth.access_token(req.session.oauth.token, req.session.oauth.token_secret, verifier, (error, oauth_access_token, oauth_access_token_secret, results) ->
        if error
            console.log 'oauth access_token error: ' + sys.inspect(error)
        else
            req.oauth.access_token = oauth_access_token
            req.oauth.access_token_secret = oauth_access_token_secret
            res.redirect '/library'
    )

app.get '/library', (req, res) ->
    res.end 'Your library'

app.listen(20008)
console.log 'WTR server started on port %s', app.address().port

