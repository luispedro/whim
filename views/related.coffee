h2 'Related Papers'
p ->
    text "Base: "
    cite @title
p ->
    text "Found #{@related.length} related papers:"
ul class: 'paper-list', ->
    for r in @related
        li ->
            cite r.title
            text ' by '
            cite r.doc.authors
            if r.present
                text " (already in your library)"
            a href: "/documents/details?uuid=#{r.uuid}", ->
                text ' [Details]'
            text '.'

