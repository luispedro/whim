doctype 5
html ->
    head ->
        meta charset: 'utf-8'
        title "Scientific Whim: What Have I Missed"
        link rel: 'stylesheet', href: '/stylesheets/style.css'
        link rel: 'stylesheet', href: '/thirdparty/css/openid.css'
        script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js'
        script src: 'http://widget.uservoice.com/J9Ceur8DmPRWdJZ60grwUA.js', async: 'true'
        coffeescript ->
            _gaq = _gaq || []
            _gaq.push ['_setAccount', 'UA-22909242-1']
            _gaq.push ['_trackPageview']
            ga = document.createElement('script')
            ga.type = 'text/javascript'
            ga.async = true
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'
            s = document.getElementsByTagName('script')[0]
            s.parentNode.insertBefore(ga, s)
    body ->
        div id: 'container', ->
            div id: 'header', ->
                h1 'Scientific Whim: What Have I Missed'
                div id: 'buttons', ->
                    a href: '/', -> text "Home"
                    if @user?
                        a href: '/library/show-delayed', -> text "My Library"
                        a href: '/recommended/show-delayed', -> text "Recommended"
                    else
                        a href: '/user/login', -> text "Login"
                    a href: '/about', -> text "About"
                    if @user?
                        a href: '/user/logout', -> text "Logout"
            div ->
                @body
            div id: 'footer', ->
                p ->
                    text 'Copyright 2011 by <a href="http://luispedro.org">Luis Pedro Coelho</a>.'
