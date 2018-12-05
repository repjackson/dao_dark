Template.nav.events
    'click .add_doc': ->
        new_id = Docs.insert {}
        
        
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
        