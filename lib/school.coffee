if Meteor.isClient
    Template.school.onCreated ->
        @autorun => Meteor.subscribe 'school'
        
        
    Template.school.helpers
        courses: -> 
            Docs.find
                type:'course'
        
        
    Template.school.events
        'click .add_course': ->
            Docs.insert
                type:'course'
        
        
        
        
        
if Meteor.isServer
    Meteor.publish 'school', ->
        Docs.find
            type:'course'