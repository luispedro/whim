sys = require 'sys'
openid = require 'openid'

oauth = require '../mendeley'
models = require '../models'

extensions = [new openid.SimpleRegistration(
                    nickname: true
                    email: true
                    )]
host = 'http://whim.no.de'
if process.env.NODE_ENV == 'development'
    host = 'http://127.0.0.1:20008'
openid_rparty = new openid.RelyingParty "#{host}/user/openid_verify", null, false, false, extensions

login = (req, res) ->
    res.render 'user/login'

openid_authenticate = (req, res) ->
    if not req.query.openid_id?
        res.redirect '/user/login'
        return
    openid_id = req.query.openid_id
    openid_rparty.authenticate openid_id, false, (authurl) ->
        if not authurl
            res.render 'error'
        else
            res.redirect authurl

openid_verify = (req, res) ->
    openid_rparty.verifyAssertion req, (result) ->
        if result.authenticated
            models.User.findOne { login: "openid:#{req.session.openid_id}" }, (err, user) ->
                if err
                    res.render 'error', error: err
                else
                    if not user?
                        user = new models.User
                        user.visits = 1
                        user.first_visit = new Date
                        user.login = ["openid:#{result.claimedIdentifier}"]
                    req.session.user = user
                    if result.email
                        user.email = result.email
                    if result.nickname
                        user.displayname = result.nickname
                    ++user.visits
                    user.last_access = new Date()
                    user.save (err) ->
                        if err
                            console.log "[user saving error] #{sys.inspect err}"
                            res.render 'error', error: err
                        else
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
            res.render 'error', error: sys.inspect(result)


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

logout = (req, res) ->
    delete req.session.user
    delete req.session.openid_id
    res.render 'user/logout'

@register_urls = (app) ->
    app.namespace '/user', ->
        app.get 'login', login
        app.get 'finish', finish
        app.get 'openid_authenticate', openid_authenticate
        app.get 'openid_verify', openid_verify
        app.get 'logout', logout

