mongoose = require('mongoose')
mongoose.connect 'mongodb://localhost/home/luispedro/work/whim/data' 
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Document = new Schema(
            { doi : { type: String, index: true }
            , title : String
            , uuid : { type: String, index: true }
            })

Library = new Schema(
            { username : String
            , documents : [Document]
            })
Related = new Schema(
            { base : { type: String, index: true }
            , related : [String]
            })
mongoose.model('Document', Document)
@Document = mongoose.model('Document')

mongoose.model('Library', Library)
@Library = mongoose.model('Library')

mongoose.model('Related', Related)
@Related = mongoose.model('Related')


