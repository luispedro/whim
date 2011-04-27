coffeekup = require('coffeekup')

express_adapt = (template) ->
    (options = {}) ->
        ck_options = options
        ck_options.context ?= {}
        for key,val of options
            ck_options.context[key] = val
        template.call(this, ck_options)

@compile = (template, options = {}) ->
    express_adapt coffeekup.compile(template, options)

