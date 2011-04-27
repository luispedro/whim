async = require('async')
_ = require('underscore')
sys = require('sys')

models = require('../models')

stats = (req, res) ->
    models.User.count {}, (err, usercount) ->
        if err
            res.render 'error', error: err
        else
            res.render 'stats', usercount: usercount
    

@register_urls = (app) ->
    app.get '/stats', stats
