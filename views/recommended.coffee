h2 'Your Recommentations'
p 'Found '+@documents.length+' recommendations'
ul ->
    for doc in @documents
        li ->
            cite doc.doc.title
            text " recommended by #{doc.hits} of your papers"
            if doc.present
                text " (already in your library)."
            else
                a href: "/library/add?uuid=#{doc.uuid}", ->
                    strong ' Add To your library'
                text '.'

