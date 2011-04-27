p   ->
    text "Retrieving your library..."
p ->
    text    """
            This process may take a while (especially if you have many
            documents in your library).
            """
p ->
    text 'You will be redirected when it is done. If it takes too long, '
    a href: '/library/show', -> text 'continue'
    text '.'

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
