Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId

Meteor.users.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId



Meteor.publish 'delta', ->
    Docs.find
        type:'delta'
        
    
Meteor.publish 'user', (user_id)->
    Meteor.users.find user_id
        
Meteor.publish 'users', ()->
    Meteor.users.find {}
        
Meteor.publish 'type', (type)->
    Docs.find type:type
        
    
Meteor.publish 'doc', (id)->
    Docs.find
        _id:id
        
    
    
