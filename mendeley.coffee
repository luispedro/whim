OAuth = require('oauth').OAuth

if not process.env.MENDELEY_KEY?
    console.log "No KEY"
if not process.env.MENDELEY_SECRET?
    console.log "No SECRET"

oa = new OAuth(
            'http://api.mendeley.com/oauth/request_token/',
            'http://api.mendeley.com/oauth/access_token/',
            process.env.MENDELEY_KEY,
            process.env.MENDELEY_SECRET,
            '1.0',
            'oob',
            "PLAINTEXT")
@base_url = 'http://api.mendeley.com/'
@request_token = (cb) -> oa.getOAuthRequestToken cb
@access_token = (ot, ots, v, cb) -> oa.getOAuthAccessToken ot, ots, v, cb
@get_protected = (u, ot, ots, cb) -> oa.get (exports.base_url + u), ot, ots, cb
@post = (u, ot, ots, body, cb) -> oa.post (exports.base_url + u), ot, ots, body, cb
