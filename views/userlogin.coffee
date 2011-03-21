h1 'Login Below'
form action: "/mendeleyauth", method: 'get', ->
    p ->
        label 'Your Mendeley Username: ', for: 'mendeleyusername'
        input type: 'text', id: 'mendeleyusername', name: 'mendeleyusername'
    input type: 'submit'

