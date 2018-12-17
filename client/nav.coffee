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
            
    'click .library': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'library'
            
    'click .time': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'time'
            
    'click .chat': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'conversations'
    
    'click .users': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'users'
            
    'click .mail': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'mail'
            
    'click .school': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'school'
            
    'click .blog': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'blog'
            
    'click .bookmarks': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'bookmarks'
            
    'click .logout': -> Meteor.logout()
            
            