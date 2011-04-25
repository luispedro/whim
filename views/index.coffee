div id: 'header', ->
    h1 'WHIM | What Have I Missed'
div id: 'content', ->
    p   """
        Scientific whim (for <em>what have I missed</em>) is a simple app that
        takes your mendeley library and recommends papers for you to read.
        """
    p   """
        The name derives from the fear that you have missed something. Now,
        with <em>scientific whim</em>, you will not miss anything anymore.
        """

    p ->
        strong "Whim is in ALPHA version. There will be bugs."

    p ->
        a href: "/user", ->
            text "I understand, let me try it out."
    
