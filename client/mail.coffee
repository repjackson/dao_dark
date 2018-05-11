FlowRouter.route '/mail', action: ->
    BlazeLayout.render 'layout', main: 'mail'

Template.mail.onCreated ->
    @autorun -> Meteor.subscribe 'messages'
    @autorun -> Meteor.subscribe 'conversations'

Template.mail.helpers
    conversations: ->
        Docs.find
            type:'conversation'


Template.mail.events
    'click #new_conversation': ->
        Docs.insert
            type:'conversation'