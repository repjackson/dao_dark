Template.add_button.events
    'click .add': ->
        Docs.insert
            type: @type

            
Template.remove_button.events
    'click .remove': ->
        if confirm "remove #{@type}?"
            Docs.remove @_id
            
            
            
    
Template.detect_fields_button.events
    'click .detect_fields': ->
        console.log @
        Meteor.call 'detect_fields', @_id
            
            
Template.voting_buttons.events
    'click .upvote': ->
        console.log @
        Docs.update @_id,
            $addToSet: upvoter_ids:Meteor.userId()
            $inc:points:1
            
            
    'click .downvote': ->
        console.log @
        Docs.update @_id,
            $addToSet: upvoter_ids:Meteor.userId()
            $inc:points:-1
            
            
            