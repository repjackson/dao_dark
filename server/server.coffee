Docs.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId

Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.private.cloudinary.cloudinary_key
    api_secret: Meteor.settings.private.cloudinary.cloudinary_secret

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


Meteor.publish 'child_docs', (parent_id)->
    Docs.find {parent_id: parent_id},
        limit: 20
    
Meteor.publish 'my_children', (parent_id)->
    Docs.find {
        author_id: Meteor.userId()
        parent_id: parent_id
    }, limit: 10
        
Meteor.publish 'parent_doc', (child_id)->
    child_doc = Docs.findOne child_id
    if child_doc
        Docs.find
            _id: child_doc.parent_id
    



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
    
    
Meteor.publish 'user_from_username', (username)->
    Meteor.users.find username:username
    
Meteor.publish 'user_from_id', (user_id)->
    # console.log user_id
    Meteor.users.find user_id
    
    
    
Meteor.publish 'page', (slug)->
    Docs.find
        type:'page'
        slug:slug



Meteor.publish 'page_children', (slug)->
    page = Docs.findOne
        type:'page'
        slug:slug
    console.log page
    Docs.find
        parent_id:page._id



Meteor.publish 'page_modules', (slug)->
    page = Docs.findOne
        type:'page'
        slug:slug
    if page
        Docs.find
            parent_id:page._id
    
    
    
            
        
Meteor.publish 'schemas', (dev_mode)->
    if dev_mode
        Docs.find
            type:'schema'
    else
        if Meteor.user()
            Docs.find
                type:'schema'
                # view_roles:$in:Meteor.user().roles
        else
            Docs.find
                type:'schema'
                # view_roles:$in:['public']
        
        
        
Meteor.publish 'schema_bricks_from_slug', (tribe_slug, slug)->
    schema = Docs.findOne
        type:'schema'
        slug:slug
        tribe:tribe_slug
    Docs.find
        type:'brick'
        parent_id:schema._id
        
        
        
Meteor.publish 'bricks_from_doc_id', (id)->
    doc = Docs.findOne id
    schema = Docs.findOne
        type:'schema'
        slug:doc.type
    Docs.find
        type:'brick'
        parent_id:schema._id
        
        
Meteor.publish 'my_delta', ->
    Docs.find
        _author_id:Meteor.userId()
        type:'delta'

        
Meteor.publish 'schema_from_slug', (tribe_slug, slug)->
    tribe = 
        Docs.findOne 
            type:'tribe'
            slug:tribe_slug
    Docs.find
        type:'schema'
        slug:slug
        tribe:tribe_slug
        
Meteor.publish 'schema_from_doc_id', (id)->
    doc = Docs.findOne id
    Docs.find
        type:'schema'
        slug:doc.type
    
    
        
        
    