if Meteor.isClient
    Template.library.onCreated ->
        @autorun => Meteor.subscribe 'library'
        
        
    Template.library.helpers
        items: -> 
            Docs.find
                type:'item'
        
        
    Template.library.events
        'click .add_item': ->
            Docs.insert
                type:'item'
        
        
        
        
        
if Meteor.isServer
    Meteor.publish 'library', ->
        Docs.find
            type:'item'