div id: 'header', ->
    h1 'Scientific: What Have I Missed'
    
    div id: 'buttons', ->
        a href: '/', -> text "Home"
        a href: '/library', -> text "My Library"
        a href: '/recommended', -> text "Recommended"
        a href: '/about', -> text "About"
        a href: '/logout', -> text "Logout"

div id: 'content', ->
    h2 'What'
    p   """
        Scientific Whim (for <em>what have I missed</em>) is a simple app that
        takes your mendeley library and recommends papers for you to read.
        """
    h2 'Who'
    p   """
        Scientific Whim is written by <a href="http://luispedro.org">Luis Pedro
        Coelho</a>. You can email him at <tt>luis at luispedro dot org</tt>
        """
    h2 'When'
    p   """
        Scientific Whim came about in early 2011 because of mendeley's competition.
        """
    h2 'Why'
    p   """
        Because Luis always wanted to have this functionality for himself.
        """
    h2 'How'
    p   """
        Currently, whim only aggregates the returns from Mendeley's <em>related
        papers</em> feature. As it matures, it might start doing its own thing.
        """

