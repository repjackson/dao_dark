if Meteor.isClient
    Template.blog.onCreated ->
        @autorun => Meteor.subscribe 'blog'
        
        
    Template.blog.helpers
        posts: -> 
            # if Meteor.user().editing_id
            #     Docs.find Meteor.user().editing_id
            # else
            Docs.find { type:'post' }, sort:timestamp:-1
        
        
    Template.blog.events
        'click .add_post': ->
            Docs.insert
                type:'post'
        
        
        
if Meteor.isServer
    Meteor.publish 'blog', ->
        Docs.find
            type:'post'