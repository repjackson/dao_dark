Template.edit_button.events
    'click .edit': ->
        Meteor.users.update Meteor.userId(), 
            $set:editing_id:@_id
            
    'click .save': ->
        Meteor.users.update Meteor.userId(),
            $set:editing_id:null
            
            
            
Template.view_button.events
    'click .view': ->
        Meteor.users.update Meteor.userId(), 
            $set:
                current_page: @template
                viewing_id:parent._id
            