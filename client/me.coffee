Template.account.onCreated ->
    @autorun -> Meteor.subscribe 'schema', 'tribe'
    
    
Template.account.events
    'click .new_tribe': ->
        Docs.insert
            title:'new tribe'
            schema:'tribe'
            
            
    'click .select_tribe': ->
        Meteor.users.update Meteor.userId(),
            $set: current_tribe_id: @_id
        
        
    'click .unselect_tribe': ->
        Meteor.users.update Meteor.userId(),
            $unset: current_tribe_id: 1
        
        
Template.account.helpers
    selected: ->
        if Meteor.user().current_tribe_id and @_id is Meteor.user().current_tribe_id then true else false
        
    my_tribes: ->
        Docs.find schema:'tribe'
        
    tribe_class: ->
        if Meteor.user().current_tribe_id and @_id is Meteor.user().current_tribe_id then 'blue' else 'secondary'
        