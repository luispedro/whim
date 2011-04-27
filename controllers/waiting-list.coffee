sys = require('sys')

models = require('../models')

signup = (req, res) ->
    waiting_list = new models.WaitingList()
    waiting_list.name = req.body.name
    waiting_list.email = req.body.email
    waiting_list.save (err) ->
        if err
            res.render 'error', error: err
        else
            res.render 'waiting-list', context: { email: waiting_list.email }


@register_urls = (app) ->
    app.namespace '/waiting-list', ->
        app.post '/signup', signup
