express = require('express')
sys = require('sys')
redis_store = require('connect-redis')
_ = require('underscore')
stylus = require 'stylus'

oauth = require('./login')
models = require('./models')
related = require('./related').related
handle_library = require('./library').handle_library
handle_recommended = require('./controllers/recommended').handle_recommended
user_controller = require './controllers/users'

app = express.createServer()
app.configure ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.session { secret: 'the mouse ran up the clock', store: new redis_store() }

    app.register '.coffee', require('coffeekup')
    app.set 'view engine', 'coffee'

    app.use stylus.middleware({ src: __dirname + '/public' })
    app.use app.router
    app.use express.static(__dirname + '/public')

app.configure 'development', ->
    app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.get '/', (req, res) ->
    res.redirect '/user'


app.get '/user', user_controller.user
app.get '/mendeleyauth', user_controller.mendeleyauth

app.get '/userlogin/', (req, res) ->
    verifier = req.query.oauth_verifier

    oauth.access_token req.session.oauth.token, \
                        req.session.oauth.token_secret, \
                        verifier, \
                        (error, oauth_access_token, oauth_access_token_secret, results) ->
        if error
            console.log 'oauth access_token error: ' + sys.inspect(error)
            res.render 'error', context: { error_message: ('Error '+error.statusCode+' in retrieving access token.') }
        else
            req.session.oauth.access_token = oauth_access_token
            req.session.oauth.access_token_secret = oauth_access_token_secret
            res.redirect '/library'

app.get '/library', handle_library
app.get '/related', related
app.get '/recommended', handle_recommended

app.listen process.env.PORT
console.log 'WTR server started on port %s', app.address().port

