if Meteor.isClient
    Template.mail.onCreated ->
        @autorun => Meteor.subscribe 'messages'
        
        
    Template.mail.helpers
        messages: -> 
            Docs.find { type:'message' }, sort:timestamp:-1
        
        
    Template.mail.events
        'click .add_message': ->
            Docs.insert
                type:'message'
        
        
        
        
        
if Meteor.isServer
    Meteor.publish 'messages', ->
        Docs.find
            type:'message'