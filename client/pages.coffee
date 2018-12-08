Template.schemas.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'schema'
    
    
Template.schemas.helpers
    schemas: -> Docs.find type:'schema'
    
    
Template.schemas.events
    'click .add_schema': ->
        Docs.insert
            type:'schema'
            title: 'new schema'