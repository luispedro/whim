private = require('./mendeley_private')
OAuth = require('oauth').OAuth
oa = new OAuth(
            'http://api.mendeley.com/oauth/request_token/',
            'http://api.mendeley.com/oauth/access_token/',
            private.key,
            private.secret,
            '1.0',
            'oob',
            "PLAINTEXT")
@request_token = (cb) -> oa.getOAuthRequestToken cb
@access_token = (ot, ots, v, cb) -> oa.getOAuthAccessToken ot, ots, v, cb
@get_protected = (u, ot, ots, cb) -> oa.get u, ot, ots, cb
