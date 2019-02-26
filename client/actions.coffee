Template.view_section.events
    'click .view_section': ->
        # console.log @
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', @slug, ->
            Session.set 'loading', false
            
            
            
Template.enter_tribe.events
    'click .enter_tribe': ->
        # console.log @

Template.checkin.helpers
    is_checkedin: ->
        

Template.checkin.events
    'click .checkin': (e,t)->
        swal {
            title: "Checkin #{@username}?"
            # text: 'This will also delete the messages.'
            type: 'info'
            showCancelButton: true
            animation: false
            confirmButtonColor: 'green'
            confirmButtonText: 'Check In'
            closeOnConfirm: true
        }, =>
            $(e.currentTarget).closest('.ui.card').transition('zoom')
            Meteor.setTimeout =>
                Docs.update @_id,
                    $set:healthclub_checkedin:true
                Docs.insert 
                    type:'log_event'
                    object_id:@_id
                    body: "#{@username} checked in."
            , 1000
            
            
    'click .checkout': (e,t)->
        swal {
            title: "Checkout #{@username}?"
            # text: 'This will also delete the messages.'
            type: 'success'
            showCancelButton: true
            animation: false
            confirmButtonColor: 'orange'
            confirmButtonText: 'Checkout'
            closeOnConfirm: true
        }, =>
            $(e.currentTarget).closest('.ui.card').transition('zoom')
            Meteor.setTimeout =>
                Docs.update @_id,
                    $set:healthclub_checkedin:false
                Docs.insert 
                    type:'log_event'
                    object_id:@_id
                    body: "#{@username} checked out."
            , 1000
