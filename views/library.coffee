doctype 5
html ->
    head ->
        meta charset: 'utf-8'
        title "Scientific Whim: What Have I Missed"
    body ->
        h1 "Scientific Whim : Your library"
        ul ->
            li d for d in @library

