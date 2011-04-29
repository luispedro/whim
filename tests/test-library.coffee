assert = require 'assert'

library = require '../controllers/library'

@test_library_mendeley_doc = (done) ->
    doc =
        title: 'testing'
        authors: 'me and some other people'
    library.mendeley_doc '983095c0-6d01-11df-a2b2-0026b95e3eb7', doc, (err,doc) ->
        assert.ok (not err)
        done()
