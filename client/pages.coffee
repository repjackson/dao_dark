Template.health_club_dashboard.onCreated ->
    @autorun => Meteor.subscribe 'health_club_members', Session.get('username_query')
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
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 3000
    

Template.health_club_dashboard.helpers
    checkedin_members: ->
        Meteor.users.find
            health_club_checkedin:true
    
    checkedout_members: ->
        username_query = Session.get('username_query')
        Meteor.users.find({
            username: {$regex:"#{username_query}", $options: 'i'}
            health_club_checkedin:$ne:true
            }).fetch()


    events: ->
        Docs.find {
           type:'log_event'
        }, sort:_timestamp:-1
        
        


Template.health_club_dashboard.events
    'click .signin': (e,t)->
        console.log @
    'click .sign_waiver': (e,t)->
        # console.log @
        receipt_id = Docs.insert
            type:'rules_and_regulations_acknowledgement'
            resident_residence:@_id
            is_resident:true
        Router.go "/t/goldrun/sign_waiver/#{receipt_id}"
        
        
        
    'keyup .username_search': (e,t)->
        username_query = $('.username_search').val()
        Session.set 'username_query',username_query


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
                Docs.insert 
                    type:'log_event'
                    object_id:res
                    body: "#{username} was created."
                Docs.insert 
                    type:'log_event'
                    object_id:res
                    body: "#{username} checked in."

                Router.go "/t/goldrun/p/health_club_dashboard"
        
        
Template.add_resident.helpers
    permission: -> Session.get 'permission'
    
        
      
      
Template.sign_waiver.onCreated ->
    @autorun => Meteor.subscribe 'doc', Router.current().params.receipt_id
    @autorun => Meteor.subscribe 'document_from_slug', 'rules_regs'
      
        
Template.sign_waiver.helpers
    receipt_doc: -> Docs.findOne Router.current().params.receipt_id
    waiver_doc: ->
        Docs.findOne
            type:'document'
            slug:'rules_regs'
        
        
        
        