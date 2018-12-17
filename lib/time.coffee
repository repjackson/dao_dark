if Meteor.isClient
    Template.time.onCreated ->
        @autorun => Meteor.subscribe 'time'
        
        
    Template.time.helpers
        entries: -> 
            if Meteor.user().editing_id
                Docs.find Meteor.user().editing_id
            else
                Docs.find { type:'entry' }, sort:timestamp:-1
        
        
    Template.time.events
        'click .add_entry': ->
            Docs.insert
                type:'entry'
        
        
        
        
        
if Meteor.isServer
    Meteor.publish 'time', ->
        Docs.find
            type:'entry'