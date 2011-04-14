h1 'Your Library'
p 'Found '+@nr_uuids+' usable documents (out of '+(@documents.length)+')'
ul ->
    for doc in @documents
        li ->
            if doc.uuid?
                a href: 'http://127.0.0.1:20008/related?uuid='+doc.uuid, ->
                    doc.title
            else
                text doc.title

