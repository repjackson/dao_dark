Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId


Meteor.publish 'type', (type)->
    Docs.find type:type
        
    
Meteor.publish 'doc', (id)->
    Docs.find
        _id:id
        
    
    
