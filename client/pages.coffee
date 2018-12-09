Template.modules.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'module'
    
    
Template.modules.helpers
    modules: -> Docs.find type:'module'
    
    
Template.modules.events
    'click .add_module': ->
        Docs.insert
            type:'module'
            title: 'new module'