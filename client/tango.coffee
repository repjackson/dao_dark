Template.goldrun.onCreated ->
    @autorun => Meteor.subscribe 'health_club_members', Session.get('username_query')
    # @autorun => Meteor.subscribe 'type', 'field'
    # @autorun => Meteor.subscribe 'type', 'log_event'
    @autorun => Meteor.subscribe 'all_users'
    # @autorun => Meteor.subscribe 'tribe_schemas', Router.current().params.tribe_slug
    # @autorun => Meteor.subscribe 'tribe_from_slug', Router.current().params.tribe_slug


Template.goldrun.onRendered ->
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


Template.goldrun.helpers
    selected_person: ->
        Meteor.users.findOne Session.get('selected_user_id')

    checkedin_members: ->
        Meteor.users.find
            healthclub_checkedin:true

    checkedout_members: ->
        username_query = Session.get('username_query')
        Meteor.users.find({
            username: {$regex:"#{username_query}", $options: 'i'}
            healthclub_checkedin:$ne:true
            },{ limit:5 }).fetch()

    checking_in: ->
        Session.get('checking_in')
    is_query: ->
        Session.get('username_query')

    events: ->
        Docs.find {
           type:'log_event'
        }, sort:_timestamp:-1


Template.checkin_button.events
    'click .checkin': (e,t)->
        $(e.currentTarget).closest('.card').transition('scale')
        Meteor.setTimeout =>
            Meteor.users.update @_id,
                $set:healthclub_checkedin:true
            # Docs.insert
            #     type:'log_event'
            #     object_id:@_id
            #     body: "#{@username} checked in."
            # swal( "#{@username} checked in.", "", "success" )
            Session.set 'username_query',null
            Session.set 'checking_in',false
            $('.username_search').val('')
        , 750

        # Session.set('selected_user_id', @_id)
        # $('.ui.check_in.modal')
        #   .modal({
        #     inverted: true
        #     setting: transition: 'scale'
        #     # closable: false
        #     onDeny: ->
        #     onApprove: =>
        #         Meteor.setTimeout =>
        #             $(e.currentTarget).closest('.card').transition('scale')
        #         , 750
        #         Meteor.setTimeout =>
        #             Meteor.users.update @_id,
        #                 $set:healthclub_checkedin:true
        #             Docs.insert
        #                 type:'log_event'
        #                 object_id:@_id
        #                 body: "#{@username} checked in."
        #             # swal( "#{@username} checked in.", "", "success" )
        #             Session.set 'username_query',null
        #             $('.username_search').val('')
        #         , 2000
        #     }).modal('show')


    'click .checkout': (e,t)->
        $(e.currentTarget).closest('.card').transition('scale')
        Meteor.setTimeout =>
            Meteor.users.update @_id,
                $set:healthclub_checkedin:false
            # Docs.insert
            #     type:'log_event'
            #     parent_id:@_id
            #     object_id:@_id
            #     body: "#{@username} checked out."
            # swal( "#{@username} checked out.", "", "success" )
            Session.set 'username_query',null
            $('.username_search').val('')
        , 1000

        # Session.set('selected_user_id', @_id)
        # $('.ui.check_out.modal')
        #   .modal({
        #     inverted: true
        #     setting: transition: 'scale'
        #     # closable: false
        #     onDeny: ->
        #     onApprove: =>
        #         Meteor.setTimeout =>
        #             $(e.currentTarget).closest('.card').transition('scale')
        #         , 750
        #         Meteor.setTimeout =>
        #             Meteor.users.update @_id,
        #                 $set:healthclub_checkedin:false
        #             Docs.insert
        #                 type:'log_event'
        #                 parent_id:@_id
        #                 object_id:@_id
        #                 body: "#{@username} checked out."
        #             # swal( "#{@username} checked out.", "", "success" )
        #             Session.set 'username_query',null
        #             $('.username_search').val('')
        #         , 2000
        #   }).modal('show')





Template.goldrun.events
    'click .sign_waiver': (e,t)->
        # console.log @
        receipt_id = Docs.insert
            type:'rules_and_regulations_acknowledgement'
            resident_residence:@_id
            is_resident:true
        Router.go "/sign_waiver/#{receipt_id}"


    'click .username_search': (e,t)->
        Session.set 'checking_in',true

    'keyup .username_search': (e,t)->
        username_query = $('.username_search').val()
        Session.set 'username_query',username_query

    'click .clear_results': ->
        Session.set 'username_query',null
        Session.set 'checking_in',false
        $('.username_search').val('')



Template.add_resident.onCreated ->
    Session.set 'permission', false

Template.add_resident.events
    'keyup #last_name': (e,t)->
        first_name = $('#first_name').val().toLowerCase()
        last_name = $('#last_name').val().toLowerCase()
        $('#username').val("#{first_name}_#{last_name}")
        Session.set 'permission',true

    'click .create_and_checkin': ->
        first_name = $('#first_name').val().toLowerCase()
        last_name = $('#last_name').val().toLowerCase()
        username = "#{first_name}_#{last_name}"
        Meteor.call 'add_resident', first_name, last_name, username, (err,res)->
            if err
                alert err
            else
                Meteor.users.update res,
                    $set:
                        first_name:first_name
                        last_name:last_name
                        healthclub_checkedin:true
                Docs.insert
                    type:'log_event'
                    object_id:res
                    body: "#{username} was created."
                Docs.insert
                    type:'log_event'
                    object_id:res
                    body: "#{username} checked in."
                Session.set 'username_query',null
                $('.username_search').val('')

                Router.go "/goldrun"


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
