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
    
    p ->
        a id: 'add-to-mailing-list-button', href: '#', ->
            text "Let me know when it's ready."

    coffeescript ->
        ($ '#add-to-mailing-list-button').click ->
            ($ '#add-to-mailing-list').show()

    div id: 'add-to-mailing-list', style: 'display: none', ->
        p   "Eventually a signup box will appear here."
        p   """"
            For now, you can email the author at <a
            href='mailto:luis@luispedro.org'>luis@luispedro.org</a> telling him
            you want to be added to the mailing list.
            """
