express = require('express')
sys = require('sys')
oauth = require('./login')

app = express.createServer()
app.use express.bodyParser()
app.use express.methodOverride()

app.get '/user', (req, res) ->
    oauth.request_token (error, oauth_token, oauth_token_secret, results) ->
        if error
            console.log 'oauth request_token error: ' + sys.inspect(error)
        else
            res.redirect 'http://www.mendeley.com/oauth/authorize/?oauth_token=' + oauth_token + '&oauth_callback=oob'

app.get '/user', (req, res) ->
    oauth.access_token oauth_token, oauth_token_secret, (error, oauth_access_token, oauth_access_token_secret, results2) ->
        if error
            console.log 'oauth access_token error: ' + sys.inspect(error)
        else
            console.log 'oauth_access_token: ' + oauth_access_token
            console.log 'oauth_token_secret: ' + oauth_access_token_secret

app.listen(20008)
console.log 'WTR server started on port %s', app.address().port

