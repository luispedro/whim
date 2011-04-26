div id: 'header', ->
    h1 'Scientific: What Have I Missed'
    
    div id: 'buttons', ->
        a href: '/', -> text "Home"
        a href: '/library', -> text "My Library"
        a href: '/recommended', -> text "Recommended"
        a href: '/about', -> text "About"
        a href: '/logout', -> text "Logout"

div id: 'content', ->
    p   ->
        text "Retrieving your library..."
        a href: '/library/show', -> text 'continue'
        coffeescript ->
            check_ready = ->
                $.ajax
                    url: '/library/ready'
                    dataType: 'json'
                    success: (data) ->
                        if data.available
                            $(window.location).attr 'href', '/library/show'
                        else
                            window.setTimeout check_ready, 1000
                    error: (err) ->
                        alert "error in AJAX"
            window.setTimeout check_ready, 1000
