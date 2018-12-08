Template.account.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'tribe'
    
    
Template.account.events
    'click .new_tribe': ->
        Docs.insert
            title:'new tribe'
            type:'tribe'
            
            
    'click .select_tribe': ->
        Meteor.users.update Meteor.userId(),
            $set: current_tribe_id: @_id
        
        
Template.account.helpers
    my_tribes: ->
        Docs.find type:'tribe'
        
    tribe_class: ->
        if Meteor.user().current_tribe_id and @_id is Meteor.user().current_tribe_id then 'blue' else 'secondary'
        