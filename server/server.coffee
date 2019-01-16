Docs.allow
    insert: (userId, doc) -> doc._author_id is userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> doc._author_id is userId

Meteor.users.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId

Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id
    
    
Meteor.publish 'users', ()->
    Meteor.users.find {}

Meteor.publish 'type', (type)->
    Docs.find
        type:type


Meteor.publish 'user', (username)->
    Meteor.users.find username:username

Meteor.publish 'docs', (selected_tags, selected_author_ids)->
    match = {}

    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids

    Docs.find match,
        limit: 3
        sort: timestamp: -1
        
        
        
Meteor.publish 'tags', (selected_tags, selected_author_ids)->
    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids

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
            name: tag.name
            count: tag.count

    self.ready()