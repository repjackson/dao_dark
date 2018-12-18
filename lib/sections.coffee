if Meteor.isClient
    Template.sections.onCreated ->
        @autorun => Meteor.subscribe 'sections'
        
        
    Template.sections.helpers
        sections: -> 
            Docs.find
                type:'section'
        
    Template.sections.events
        'click .add_section': ->
            Docs.insert
                type:'section'
        
        
if Meteor.isServer
    Meteor.publish 'sections', ->
        Docs.find
            type:'section'