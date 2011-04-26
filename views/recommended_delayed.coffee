p   ->
    text "Computing your recommendations..."
coffeescript ->
    check_ready = ->
        $.ajax
            url: 'ready'
            dataType: 'json'
            success: (data) ->
                if data.available
                    $(window.location).attr 'href', 'show'
                else
                    window.setTimeout check_ready, 1000
            error: (err) ->
                alert "error in AJAX"
    window.setTimeout check_ready, 1000
