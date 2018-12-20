Template.add_button.events
    'click .add': ->
        Docs.insert
            type: @type

            
Template.remove_button.events
    'click .remove': ->
        if confirm "remove #{@type}?"
            Docs.remove @_id
            
            