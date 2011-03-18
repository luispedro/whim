private = require('./mendeley_private')
OAuth = require('oauth').OAuth
oa = new OAuth(
            'http://www.mendeley.com/oauth/request_token/',
            'http://www.mendeley.com/oauth/access_token/',
            private.key,
            private.secret,
            '1.0',
            'oob',
            "PLAINTEXT")
@request_token = (cb) -> oa.getOAuthRequestToken cb
@access_token = (ot, ots, v, cb) -> oa.getOAuthAccessToken ot, ots, v, cb
@get_protected = (u, meth, ot, ots, cb) -> oa.getProtectedResource u, meth, ot, ots, cb
