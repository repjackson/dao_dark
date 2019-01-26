import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


Template.nav.events
    'click .add_doc': ->
        new_id = Docs.insert({})
        FlowRouter.go("/edit/#{new_id}")
    
    'click .logout': ->
        Session.set 'logging_out', true
        Meteor.logout ->
            Session.set 'logging_out', false

    'click .invert': ->
        Session.set('invert', !Session.get('invert'))



Template.nav.helpers
    logging_out: -> Session.get 'logging_out'