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
