Docs.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId


Meteor.users.allow
    insert: (userId, doc) ->
        # only admin can insert 
        u = Meteor.users.findOne(_id: userId)
        u and u.isAdmin
    update: (userId, doc, fields, modifier) ->
        # console.log 'user ' + userId + 'wants to modify doc' + doc._id
        if userId and doc._id == userId
            # console.log 'user allowed to modify own account!'
            # user can modify own 
            return true
        # admin can modify any
        u = Meteor.users.findOne(_id: userId)
        u and 'admin' in u.roles
    remove: (userId, doc) ->
        # only admin can remove
        u = Meteor.users.findOne(_id: userId)
        u and 'admin' in u.roles



Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id

Meteor.publish 'deltas', ->
    Docs.find
        type:'delta'
        

    
Meteor.publish 'schema', (doc_id)->
    doc = Docs.findOne doc_id
    Docs.find
        type:'schema'
        slug:doc.type
    
    
Meteor.publish 'type', (type)->
    Docs.find 
        type:type
    
    
Meteor.publish 'children', (doc_id)->
    Docs.find
        parent_id: doc_id

Meteor.publish 'users', ->
    Meteor.users.find()

Meteor.publish 'user_list', (doc,key)->
    Meteor.users.find _id:$in:doc["#{@key}"]





Meteor.publish 'docs', (selected_tags)->
    match = {}

    if selected_tags.length > 0 then match.tags = $all: selected_tags

    Docs.find match,
        limit: 3
        sort: timestamp: -1
        
        
        
Meteor.publish 'tags', (selected_tags)->
    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags

    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 100 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]

    cloud.forEach (tag) ->
        self.added 'tags', Random.id(),
            title: tag.name
            count: tag.count

    self.ready()


    
Meteor.publish 'docs_type', (selected_type)->
    match = {}

    if selected_type.length > 0 then match.type = $all: selected_type

    Docs.find match,
        limit: 10
        sort: timestamp: -1
        
        
    
Meteor.publish 'types', (selected_type)->
    self = @
    match = {}
    if selected_type.length > 0 then match.type = $all: selected_type

    cloud = Docs.aggregate [
        { $match: match }
        { $project: type: 1 }
        { $group: _id: '$type', count: $sum: 1 }
        { $match: _id: $nin: selected_type }
        { $sort: count: -1, _id: 1 }
        { $limit: 10 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]

    cloud.forEach (type) ->
        self.added 'types', Random.id(),
            title: type.name
            count: type.count

    self.ready()
    
    
    