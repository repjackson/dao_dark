if Meteor.isClient
    Template.tasks.onCreated ->
        @autorun => Meteor.subscribe 'tasks'
        
        
    Template.tasks.helpers
        tasks: -> 
            Docs.find
                type:'task'
        
        
    Template.tasks.events
        'click .add_task': ->
            Docs.insert
                type:'task'
        
        
        
        
        
        
        
        
        
        
if Meteor.isServer
    Meteor.publish 'tasks', ->
        Docs.find
            type:'task'