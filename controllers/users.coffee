sys = require 'sys'

oauth = require '../login'

@mendeleyauth = (req, res) ->
    req.session.username = req.query.mendeleyusername

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

