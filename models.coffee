mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/home/luispedro/work/whim/data');
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Document = new Schema(
            { doi : String
            , title : String
            , uuid : String
            })

Library = new Schema(
            { username : String
            , documents : [Document]
            })
mongoose.model('Document', Document)
@Document = mongoose.model('Document')

mongoose.model('Library', Library)
@Library = mongoose.model('Library')

