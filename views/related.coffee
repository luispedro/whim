h2 'Related Papers'
p ->
    text "Base: "
    cite @title
p ->
    text "Found #{@related.length} related papers:"
ul ->
    for r in @related
        li ->
            cite r.title
            if r.present
                text " (already in your library)"
            else
                a href: "/library/add?uuid=#{r.uuid}", ->
                    strong " Add To your library"

