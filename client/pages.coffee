Template.modules.onCreated ->
    @autorun -> Meteor.subscribe 'schema', 'module'
    
    
Template.modules.helpers
    modules: -> Docs.find schema:'module'
    
    
Template.modules.events
    'click .add_module': ->
        Docs.insert
            schema:'module'
            title: 'new module'