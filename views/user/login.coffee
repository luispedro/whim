h2 'Login Below'
script src: '/thirdparty/js/openid-jquery.js'
script src: '/thirdparty/js/openid-en.js'
form action: "/user/openid_authenticate", method: 'get', id: 'openid_form', ->
    input type: "hidden", name: "action", value: "/user/openid_authenticate"
    input type: 'hidden', name: 'csrf', value: @csrf
    fieldset ->
        legend ->
            text 'Sign-in or Create New Account'
            div id: "openid_choice", ->
                p 'Please click your account provider:'
                div id: 'openid_btns'
                div id: "openid_input_area", ->
                    input id: "openid_identifier", name: "openid_id", type: "text", value: "http://"
                    input id: "openid_submit", type: "submit", value: "Sign-In"
        noscript ->
            p ->
                text    '''
                        OpenID is service that allows you to log-on to many
                        different websites using a single indentity.  Find out
                        <a href="http://openid.net/what/">more about OpenID</a>
                        and <a href="http://openid.net/get/">how to get an
                        OpenID enabled account</a>.
                        '''
coffeescript ->
    $(document).ready ->
        openid.init 'openid_id'
