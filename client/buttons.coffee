Template.add_type_button.events
    'click .add': ->
        new_id = Docs.insert type: @type
        Session.set 'page', 'edit',     
        Session.set 'page_data', new_id

            
Template.view_user_button.events
    'click .view_user': ->
        Session.set 'page', 'user_view'
        Session.set 'page_data', @username


Template.view_button.events
    'click .view': ->
        Session.set 'page', 'view'
        Session.set 'page_data', @_id
            
Template.remove_button.events
    'click .remove': ->
        if confirm "remove #{@type}?"
            Docs.remove @_id
    
Template.detect_fields_button.events
    'click .detect_fields': ->
        console.log @
        Meteor.call 'detect_fields', @_id
            
Template.voting.helpers
    upvote_class: -> if @upvoter_ids and Meteor.userId() in @upvoter_ids then 'red' else 'outline'
    downvote_class: -> if @downvoter_ids and Meteor.userId() in @downvoter_ids then 'green' else 'outline'
            
Template.voting.events
    'click .upvote': ->
        if @downvoter_ids and Meteor.userId() in @downvoter_ids
            Docs.update @_id,
                $pull: downvoter_ids:Meteor.userId()
                $addToSet: upvoter_ids:Meteor.userId()
                $inc:points:2
        else
            Docs.update @_id,
                $addToSet: upvoter_ids:Meteor.userId()
                $inc:points:1
        Meteor.users.update @author_id,
            $inc:karma:1
            
    'click .downvote': ->
        if @downvoter_ids and Meteor.userId() in @downvoter_ids
            Docs.update @_id,
                $pull: downvoter_ids:Meteor.userId()
                $addToSet: downvoter_ids:Meteor.userId()
                $inc:points:-2
        else
            Docs.update @_id,
                $addToSet: downvoter_ids:Meteor.userId()
                $pull: upvoter_ids:Meteor.userId()
                $inc:points:-1
        Meteor.users.update @author_id,
            $inc:karma:-1
            
            
            
            
Template.bookmark_button.helpers
    bookmarkers: ->
        Meteor.users.find _id:$in:@bookmarker_ids
        
        
Template.bookmark_button.events
    'click .bookmark': ->
        Docs.update @_id,
            $addToSet: bookmarker_ids:Meteor.userId()
    
    
    