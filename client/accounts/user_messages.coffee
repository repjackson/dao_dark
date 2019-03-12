Template.user_messages.onCreated ->
    @autorun => Meteor.subscribe 'user_messages',Router.current().params.username



Template.user_messages.helpers
    user_messages: ->
        Docs.find
            type:'message'


Template.user_messages.events
    'keyup #new_message': (e,t)->
        if e.which is 13
            body = t.$('#new_message').val().trim()
            console.log body
            current_user = Meteor.users.findOne username:Router.current().params.username
            Docs.insert
                body:body
                type:'message'
                to_user_id:current_user._id
                to_username:current_user.username

            t.$('#new_message').val('')


Template.notify_message.events
    'click .notify': (e,t)->
        current_user = Meteor.users.findOne username:Router.current().params.username
        Docs.insert
            type:'log_event'
            body:"#{current_user.username} was notified about message: #{@body} by #{Meteor.user().username}."
            user_ids:[current_user._id,Meteor.userId()]
            to_user_id:current_user._id
            to_username:current_user.username
        Meteor.call 'notify_message', @_id
