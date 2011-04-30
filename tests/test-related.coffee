assert = require 'assert'

related = require '../controllers/related'

@test_by_uuid_bad = (done) ->
    related.retrieve_related_by_uuid 'xxx', (error, _ ) ->
        assert.ok error
        done()
