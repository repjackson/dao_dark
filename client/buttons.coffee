Template.add_type_button.events
    'click .add': ->
        new_id = Docs.insert type: @type
        Meteor.call 'set_page', 'edit', new_id

            
Template.view_user_button.events
    'click .view_user': -> Meteor.call 'set_page', 'user_view', @username


Template.view_button.events
    'click .view': -> Meteor.call 'set_page', 'view', @_id
Template.save_button.events
    'click .save': -> Meteor.call 'set_page', 'view', @_id
Template.edit_button.events
    'click .edit': -> Meteor.call 'set_page', 'edit', @_id
            
Template.remove_button.events
    'click .remove': ->
        if confirm "remove #{@type}?"
            Docs.remove @_id
    
Template.detect_fields_button.events
    'click .detect_fields': ->
        console.log @
        Meteor.call 'detect_fields', @_id
            
Template.voting.helpers
    upvote_class: -> if @upvoter_ids and Meteor.userId() in @upvoter_ids then '' else 'outline'
    downvote_class: -> if @downvoter_ids and Meteor.userId() in @downvoter_ids then '' else 'outline'
            
Template.voting.events
    'click .upvote': ->
        if @downvoter_ids and Meteor.userId() in @downvoter_ids
            Docs.update @_id,
                $pull: downvoter_ids:Meteor.userId()
                $addToSet: upvoter_ids:Meteor.userId()
                $inc:points:2
        else if @upvoter_ids and Meteor.userId() in @upvoter_ids
            Docs.update @_id,
                $pull: upvoter_ids:Meteor.userId()
                $inc:points:-1
        else
            Docs.update @_id,
                $addToSet: upvoter_ids:Meteor.userId()
                $inc:points:1
        Meteor.users.update @author_id,
            $inc:karma:1
            
    'click .downvote': ->
        if @upvoter_ids and Meteor.userId() in @upvoter_ids
            Docs.update @_id,
                $pull: upvoter_ids:Meteor.userId()
                $addToSet: downvoter_ids:Meteor.userId()
                $inc:points:-2
        else if @downvoter_ids and Meteor.userId() in @downvoter_ids
            Docs.update @_id,
                $pull: downvoter_ids:Meteor.userId()
                $inc:points:1
        else
            Docs.update @_id,
                $addToSet: downvoter_ids:Meteor.userId()
                $pull: upvoter_ids:Meteor.userId()
                $inc:points:-1
        Meteor.users.update @author_id,
            $inc:karma:-1
            
            
            
            
Template.bookmark_button.helpers
    bookmarkers: -> Meteor.users.find _id:$in:@bookmark_ids
    bookmark_class: -> if @bookmark_ids and Meteor.userId() in @bookmark_ids then '' else 'outline'
        
Template.bookmark_button.events
    'click .bookmark': ->
        if @bookmark_ids and Meteor.userId() in @bookmark_ids
            Docs.update @_id,
                $pull: bookmark_ids:Meteor.userId()
        else
            Docs.update @_id,
                $addToSet: bookmark_ids:Meteor.userId()
    
    
    