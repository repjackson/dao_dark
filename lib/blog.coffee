if Meteor.isClient
    Template.blog.onCreated ->
        @autorun => Meteor.subscribe 'blog'
        
        
    Template.blog.helpers
        posts: -> 
            Docs.find
                type:'post'
        
        
    Template.blog.events
        'click .add_post': ->
            Docs.insert
                type:'post'
        
        
        
        
        
if Meteor.isServer
    Meteor.publish 'blog', ->
        Docs.find
            type:'post'