if Meteor.isClient
    Template.conversations.onCreated ->
        @autorun => Meteor.subscribe 'conversations'
        
        
    Template.conversations.helpers
        conversations: -> 
            Docs.find
                type:'conversation'
        
        
    Template.conversations.events
        'click .add_conversation': ->
            Docs.insert
                type:'conversation'
        
        
        
        
        
if Meteor.isServer
    Meteor.publish 'conversations', ->
        Docs.find
            type:'conversation'