express = require('express')
sys = require('sys')
redis_store = require('connect-redis')
_ = require('underscore')
stylus = require 'stylus'
require 'express-namespace'
csrf = require 'express-csrf'

oauth = require('./login')
models = require('./models')
related = require('./related').related
library = require('./controllers/library')
recommended = require('./controllers/recommended')
user = require './controllers/users'
stats = require './controllers/stats'
waiting_list = require './controllers/waiting-list'
simple = require('./controllers/simple').simple

app = express.createServer()
app.configure ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.session { secret: 'the mouse ran up the clock', store: new redis_store() }

    app.register '.coffee', require('./lib/coffeekup-adaptor')
    app.set 'view engine', 'coffee'

    app.use stylus.middleware({ src: __dirname + '/public' })
    app.use app.router
    app.use express.static(__dirname + '/public')

    app.dynamicHelpers
        csrf: csrf.token
        user: (req, res) -> req.session.user
    app.use csrf.check()

app.configure 'development', ->
    app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.get '/', simple 'index'
app.get '/about', simple 'about'

library.register_urls app
recommended.register_urls app
user.register_urls app
stats.register_urls app
waiting_list.register_urls app

app.get '/related', related

app.listen process.env.PORT
console.log 'WTR server started on port %s', app.address().port

