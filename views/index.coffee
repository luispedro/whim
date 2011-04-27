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
        a href: "/user/login", ->
            text "I understand, let me try it out."
    
    p ->
        a id: 'add-to-mailing-list-button', href: '#', ->
            text "Let me know when it's ready."

    coffeescript ->
        ($ '#add-to-mailing-list-button').click ->
            ($ '#add-to-mailing-list').show()

    div id: 'add-to-mailing-list', style: 'display: none', ->
        p   '''
            Leave your name and email on the form below and you will get an
            email when the site is ready for prime time.
            '''
        form id: 'mailing-list', action: 'add-to-mailing-list', method: 'post',
            input type: 'hidden', name: 'csrf', value: @csrf
            p ->
                label for: 'name', 'Your name: '
                input type: 'text', name: 'name', id: 'name'
                label for: 'email', 'Your email: '
                input type: 'text', name: 'email', id: 'email'
                input type: 'submit', value: 'Submit'
