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
