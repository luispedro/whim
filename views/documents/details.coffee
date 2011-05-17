h2 'Document details'
p ->
    strong 'Title'
    text @doc.title
p ->
    strong 'Authors'
    text @doc.authors

p ->
    a href: "/documents/add?uuid=#{ @doc.uuid }", ->
        text 'Add to your library'
