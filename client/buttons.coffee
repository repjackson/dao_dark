Template.edit_button.events
    'click .edit': ->
        Meteor.users.update Meteor.userId(), 
            $set:editing_id:@_id
        Session.set 'editing', true
            
    'click .save': ->
        Meteor.users.update Meteor.userId(),
            $set:editing_id:null
        Session.set 'editing', false
            
            
Template.view_button.events
    'click .view': ->
        # Meteor.users.update Meteor.userId(), 
        #     $set:
        #         current_page: @template
        #         viewing_id:parent._id
        
            
            
Template.remove_button.events
    'click .remove': ->
        if confirm "remove #{@type}?"
            Docs.remove @_id
            
            