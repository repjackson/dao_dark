Template.nav.events
    'click .inbox': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'inbox'    
    
    'click .alerts': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'alerts'