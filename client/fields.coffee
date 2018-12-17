Template.edit_button.events
    'click .edit': ->
        Meteor.users.update Meteor.userId(), 
            $set:editing_id:@_id
            
    'click .save': ->
        Meteor.users.update Meteor.userId(),
            $set:editing_id:null
            
            
            
            