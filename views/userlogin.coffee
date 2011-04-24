div id: 'header', ->
    h1 'WHIM | What Have I Missed'
div id: 'content', ->
    h2 'Login Below'
    form action: "/mendeleyauth", method: 'get', ->
        p ->
            label 'Your Mendeley Username: ', for: 'mendeleyusername'
            input type: 'text', id: 'mendeleyusername', name: 'mendeleyusername'
        input type: 'submit'

