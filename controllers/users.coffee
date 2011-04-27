sys = require 'sys'
openid = require 'openid'

oauth = require '../login'

extensions = [new openid.SimpleRegistration(
                    nickname: true
                    email: true
                    )]
host = 'http://whim.no.de'
if process.env.NODE_ENV == 'development'
    host = 'http://127.0.0.1:20008'
openid_rparty = new openid.RelyingParty "#{host}/user/openid_verify", null, false, false, extensions

login = (req, res) ->
    res.render 'userlogin'

openid_authenticate = (req, res) ->
    if not req.query.openid_id?
        res.redirect '/user/login'
        return
    openid_id = req.query.openid_id
    openid_rparty.authenticate openid_id, false, (authurl) ->
        if not authurl
            res.render 'error'
        else
            req.session.username = openid_id
            res.redirect authurl

openid_verify = (req, res) ->
    openid_rparty.verifyAssertion req, (result) ->
        if result.authenticated
            req.session.email = result.email
            req.session.nickname = result.nickname
            oauth.request_token (error, oauth_token, oauth_token_secret, results) ->
                if error
                    console.log 'oauth request_token error: ' + sys.inspect(error)
                    res.render 'error', context: { error_message: ('Error '+error.statusCode+' in retrieving auth token.') }
                else
                    req.session.oauth = { token : oauth_token, token_secret : oauth_token_secret }
                    callback = "http://#{req.header('Host')}/user/finish"
                    callback = encodeURIComponent(callback)
                    res.redirect "#{oauth.base_url}oauth/authorize/?oauth_token=#{oauth_token}&oauth_callback=#{callback}"
        else
            console.log '[openid.verify error]'
            res.render 'error'


finish = (req, res) ->
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
            res.redirect '/library/show-delayed'

@register_urls = (app) ->
    app.namespace '/user', ->
        app.get 'login', login
        app.get 'finish', finish
        app.get 'openid_authenticate', openid_authenticate
        app.get 'openid_verify', openid_verify

