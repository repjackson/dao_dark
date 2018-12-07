
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'me'

Template.nav.events
    'click .delta': ->
        Meteor.users.update Meteor.userId(),
            $set:current_template: 'delta'
        console.log Meteor.user()

    'click .inbox': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'inbox'    
    
    'click .alerts': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'alerts'
            
            
    'click .logout': ->
        Meteor.logout()