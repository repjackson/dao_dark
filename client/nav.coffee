Template.nav.events
    'click .add_doc': ->
        new_id = Docs.insert {}
        FlowRouter.go "/edit/#{new_id}"
        
        
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
        