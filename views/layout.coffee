doctype 5
html ->
    head ->
        meta charset: 'utf-8'
        title "Scientific Whim: What Have I Missed"
        link rel: 'stylesheet', href: '/stylesheets/style.css'
        script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js'
    body ->
        div id: 'container', ->
            @body
