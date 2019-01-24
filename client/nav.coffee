Template.topnav.events
  'click .hide-menu': (event) ->
        event.preventDefault()
        if $(window).width() < 769
            $('body').toggleClass 'show-sidebar'
        else
            $('body').toggleClass 'hide-sidebar'

  'click .right-sidebar-toggle': (event) ->
        event.preventDefault()
        $('#right-sidebar').toggleClass 'sidebar-open'


  'click .logout': ->
        Session.set 'logging_out', true
        Meteor.logout ->
            Session.set 'logging_out', false

Template.topnav.helpers
    logging_out: -> Session.get 'logging_out'

Template.topnav.events
    'click #requestDemobtn': (e, t) ->
        data = {}
        data['firstName'] = $('#firstName').val()
        data['lastName'] = $('#lastName').val()
        data['emailId'] = $('#emailId').val()
        data['phoneNo'] = $('#phoneNo').val()
        data['date'] = moment($('#demoDate').val())._d
        Meteor.call 'requestForDemo', data, (err, res) ->
            if err
                alert err.reason, ''
            else
                alert 'Your request for demo submitted successfully.', ''
                $('#firstName').val ''
                $('#lastName').val ''
                $('#emailId').val ''
                $('#phoneNo').val ''
                $('#requestDemo').modal 'hide'

    'click .feedbackSubmit': (e, t) ->
        e.preventDefault()
        JsonObject =
            experience: $('#radio_experience:checked').val()
            comments: $('#comments').val()
            name: $('#feedBack_name').val()
            email: $('#feedBack_email').val()
        if !JsonObject.experience
            alert 'Please select your experinece', ''
            return false
        if !JsonObject.comments
            alert 'Please enter comments', ''
            return false
        if !JsonObject.name
            alert 'Please enter your name', ''
            return false
        if !JsonObject.email
            alert 'Please enter your email id', ''
            return false
        Meteor.call 'sendFeedbackToAdmin', JsonObject, (err, res) ->
            alert 'Thank you for submitting your feedback.'
            $('#radio_experience').val 'checked', false
            $('#comments').val ''
            $('#feedBack_name').val ''
            $('#feedBack_email').val ''
            $('#feedbackForm').modal 'toggle'

Template.topnav.onRendered ->
    Meteor.setTimeout ->
        $('.item').popup()
    , 1000

    # $('.datetimepicker').datetimepicker minDate: new Date



Template.leftbar.onCreated ->
    @autorun => Meteor.subscribe 'type', 'schema'


Template.leftbar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.left.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: false
                        delaySetup:false
                        dimPage: false
                        transition:  'push'
                    })
                    .sidebar('attach events', '.toggle_leftbar')
            , 1000

Template.topbar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.top.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: false
                        delaySetup:false
                        dimPage: false
                        transition:  'overlay'
                    })
                    .sidebar('attach events', '.toggle_topbar')
            , 1000

# Template.bottombar.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.context .ui.bottom.sidebar')
#                     .sidebar({
#                         context: $('.context .bottom.segment')
#                         exclusive: false
#                         delaySetup:false
#                         dimPage: false
#                         transition:  'overlay'
#                     })
#                     .sidebar('attach events', '.toggle_bottombar')
#             , 1000

Template.rightbar.onRendered ->
    if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.right.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: false
                        delaySetup:false
                        dimPage: false
                        transition:  'push'
                    })
                    .sidebar('attach events', '.toggle_rightbar')
            , 1000



Template.leftbar.helpers
    schemas: ->
        if Meteor.user() and Meteor.user().roles
            Docs.find {
                # view_roles: $in:Meteor.user().roles
                type:'schema'
            }, sort:title:1

Template.leftbar.events


Template.topbar.events
    'click .set_notifications': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'notification', ->
            Session.set 'is_calculating', false

    'click .set_messages': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'message', ->
            Session.set 'is_calculating', false

    'click .set_bookmarks': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'bookmark', ->
            Session.set 'is_calculating', false

    'click .set_tasks': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'task', ->
            Session.set 'is_calculating', false



Template.rightbar.onCreated ->
    @signing_out = new ReactiveVar false

Template.rightbar.events
    'click .settings': ->
        delta = Docs.findOne type:'delta'
        # console.log @
        Docs.update delta._id,
            $set:
                viewing_page:true
                page_template:'account_settings'
                viewing_delta:false


    'click .delete_delta': ->
        if confirm 'Clear Session?'
            delta = Docs.findOne type:'delta'
            Docs.remove delta._id

    'click .run_fo': ->
        delta = Docs.findOne type:'delta'
        Session.set 'is_calculating', true
        Meteor.call 'fo', (err,res)->
            if err then console.log err
            else
                Session.set 'is_calculating', false



    'click .sla': ->
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:
                viewing_page:true
                page_template:'office_sla'
                viewing_delta:false

    'click #logout': (e,t)->
        # e.preventDefault()
        t.signing_out.set true
        Meteor.logout ->
            t.signing_out.set false


Template.rightbar.helpers
    signing_out: -> Template.instance().signing_out.get()
