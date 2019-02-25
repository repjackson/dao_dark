Template.health_club_dashboard.onCreated ->
    @autorun => Meteor.subscribe 'users'
    @autorun => Meteor.subscribe 'type', 'field'
    @autorun => Meteor.subscribe 'type', 'log_event'
    @autorun => Meteor.subscribe 'tribe_schemas', Router.current().params.tribe_slug
    @autorun => Meteor.subscribe 'tribe_from_slug', Router.current().params.tribe_slug


Template.health_club_dashboard.onRendered ->
    # @autorun =>
    #     if @subscriptionsReady()
    #         Meteor.setTimeout ->
    #             $('.dropdown').dropdown()
    #         , 3000
    
    Meteor.setTimeout ->
        $('.item').popup()
    , 3000
    

Template.health_club_dashboard.helpers
    checkedin_members: ->
        Meteor.users.find
            health_club_checkedin:true
    
    checkedout_members: ->
        Meteor.users.find 
            health_club_checkedin:$ne:true


    events: ->
        Docs.find {
           type:'log_event'
        }, sort:timestamp:-1
        
        


Template.health_club_dashboard.events
    # 'click .add_user': (e,t)->
        

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
                Meteor.users.update @_id,
                    $set:health_club_checkedin:true
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
                Meteor.users.update @_id,
                    $set:health_club_checkedin:false
                Docs.insert 
                    type:'log_event'
                    object_id:@_id
                    body: "#{@username} checked out."
            , 1000

Template.add_resident.onCreated ->
    Session.set 'permission', false

Template.add_resident.events 
    'blur #last_name': (e,t)->
        first_name = $('#first_name').val().toLowerCase()
        last_name = $('#last_name').val().toLowerCase()
        $('#username').val("#{first_name}_#{last_name}")
        Session.set 'permission',true
        
    'click .create_and_checkin': ->
        first_name = $('#first_name').val().toLowerCase()
        last_name = $('#last_name').val().toLowerCase()
        username = $('#username').val()
        Meteor.call 'add_resident', first_name, last_name, username, (err,res)->
            if err
                alert err
            else
                Meteor.users.update res,
                    $set:health_club_checkedin:true
                Router.go "/t/goldrun/p/health_club_dashboard"
        
        
Template.add_resident.helpers
    permission: -> Session.get 'permission'
    
        