h1 'Your Recommentations'
p 'Found '+@documents.length+' recommendations'
ul ->
    for doc in @documents
        li ->
            text doc.title

