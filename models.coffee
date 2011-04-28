mongoose = require('mongoose')
mongoose.connect 'mongodb://localhost/whim'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Document = new Schema
            title: String
            authors: String
            doi: { type: String, index: true }
            uuid: { type: String, index: true }
            mendeley_url: { type: String, index: true }
            queried_at: Date
            response: Number

Library = new Schema
            user: ObjectId
            documents : [ObjectId]

Related = new Schema(
            { base : { type: String, index: true }
            , related : [String]
            })

User = new Schema
            login: { type: [String], index: true }
            visits: Number
            first_visit: Date
            last_visit: Date
            email: String
            displayname: String

WaitingList = new Schema
            name: String
            email: String

register = (name, schema) ->
    mongoose.model(name, schema)
    mongoose.model(name)

mongoose.model('Document', Document)
@Document = mongoose.model('Document')

mongoose.model('Library', Library)
@Library = mongoose.model('Library')

mongoose.model('Related', Related)
@Related = mongoose.model('Related')

@User = register('User', User)
@WaitingList = register('WaitingList', WaitingList)


