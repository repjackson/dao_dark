Template.nav.events
    'click .me': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'me'
            
    'click .home': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'delta'
            
            
            