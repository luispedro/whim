div id: 'header', ->
    h1 'WHIM | What Have I Missed'
div id: 'content', ->
    h2 'Login Below'
    form action: "/authenticate", method: 'get', ->
        p ->
            label 'Your OpenID: ', for: 'openid_id'
            input type: 'text', id: 'openid_id', name: 'openid_id'
            input type: 'submit', value: 'Login'

