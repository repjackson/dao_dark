Template.nav.events
    'click .me': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'me'
            
    'click .home': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'delta'
            
    'click .reddit': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'delta'
            
    'click .tasks': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'tasks'
            
    'click .chat': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'conversations'
    
    'click .users': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'users'
            
    'click .cal': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'cal'
            
    'click .bookmarks': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'bookmarks'
            
    'click .logout': -> Meteor.logout()
            
            