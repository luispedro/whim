mongoose = require('mongoose')
mongoose.connect 'mongodb://localhost/whim'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Document = new Schema(
            { doi : { type: String, index: true }
            , title : String
            , uuid : { type: String, index: true }
            , queried_at : Date
            , response : Number
            })

Library = new Schema(
            { username : String
            , documents : [ObjectId]
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


