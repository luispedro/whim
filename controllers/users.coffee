sys = require 'sys'
openid = require 'openid'

oauth = require '../login'

extensions = [new openid.SimpleRegistration(
                    nickname: true
                    email: true
                    )]
rparty = new openid.RelyingParty 'http://127.0.0.1:20008/verify', null, false, false, extensions


@authenticate = (req, res) ->
    if not req.query.openid_id?
        res.redirect '/user'
        return
    openid_id = req.query.openid_id
    rparty.authenticate openid_id, false, (authurl) ->
        if not authurl
            res.render 'error'
        else
            req.session.username = openid_id
            res.redirect authurl
@verify = (req, res) ->
    rparty.verifyAssertion req, (result) ->
        if result.authenticated
            req.session.email = result.email
            req.session.nickname = result.nickname
            res.redirect '/mendeleyauth'
        else
            console.log '[openid.verify error]'
            res.render 'error'

@mendeleyauth = (req, res) ->

    oauth.request_token (error, oauth_token, oauth_token_secret, results) ->
        if error
            console.log 'oauth request_token error: ' + sys.inspect(error)
            res.render 'error', context: { error_message: ('Error '+error.statusCode+' in retrieving auth token.') }
        else
            req.session.oauth = { token : oauth_token, token_secret : oauth_token_secret }
            callback = "http://#{req.header('Host')}/userlogin/"
            callback = encodeURIComponent(callback)
            res.redirect "#{oauth.base_url}oauth/authorize/?oauth_token=#{oauth_token}&oauth_callback=#{callback}"

@user = (req, res) ->
    res.render 'userlogin'

