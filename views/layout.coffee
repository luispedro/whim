doctype 5
html ->
    head ->
        meta charset: 'utf-8'
        title "Scientific Whim: What Have I Missed"
        link rel: 'stylesheet', href: '/stylesheets/style.css'
        script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js'
    body ->
        div id: 'container', ->
            div id: 'header', ->
                h1 'Scientific: What Have I Missed'
                div id: 'buttons', ->
                    a href: '/', -> text "Home"
                    a href: '/library/show-delayed', -> text "My Library"
                    a href: '/recommended/show-delayed', -> text "Recommended"
                    a href: '/about', -> text "About"
                    a href: '/logout', -> text "Logout"
            div ->
                @body
            div id: 'footer', ->
                p ->
                    text 'Copyright 2011 by <a href="http://luispedro.org">Luis Pedro Coelho</a>.'
