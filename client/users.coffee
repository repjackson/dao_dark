Template.users.onCreated ->
    @autorun => Meteor.subscribe 'users'
    
    
Template.users.helpers
    users: -> 
        Meteor.users.find()        
    
Template.users.events
    'click .add_user': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'add_user'
