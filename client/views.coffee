Template.day.helpers
    hours: -> [1..12]
    
Template.year.helpers
    array_days: ->
        [1..@days]
        
        
    months: ->
        [
            {
                title:'January'
                days:31
            }
            {
                title:'February'
                days:28
            }
            {
                title:'March'
                days:31
            }
            {
                title:'April'
                days:30
            }
            {
                title:'May'
                days:31
            }
            {
                title:'June'
                days:30
            }
            {
                title:'July'
                days:31
            }
            {
                title:'August'
                days:31
            }
            {
                title:'September'
                days:30
            }
            {
                title:'October'
                days:31
            }
            {
                title:'November'
                days:30
            }
            {
                title:'December'
                days:31
            }
        ]
            
            
Template.edit_button.helpers
    editing_this: ->
        if Meteor.user() and Meteor.user().current_delta_id
            delta = Docs.findOne Meteor.user().current_delta_id
            if @_id is delta.editing_id then true else false

            
Template.edit_button.events
    'click .edit': ->
        current_delta = Docs.findOne Meteor.user().current_delta_id
        Docs.update current_delta._id,
            $set: 
                editing_id: @_id
        # current_delta = Docs.findOne Meteor.user().current_delta_id
        # console.log current_delta.editing_id
    
    'click .save': ->
        current_delta = Docs.findOne Meteor.user().current_delta_id
        Docs.update current_delta._id,
            $set: 
                editing_id: null