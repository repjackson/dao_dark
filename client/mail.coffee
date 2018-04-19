FlowRouter.route '/mail', 
    name: 'mail'
    action: -> 
        BlazeLayout.render 'layout', 
            main: 'mail'



Template.mail.onCreated ->
    @autorun => Meteor.subscribe('mail')

Template.mail.helpers
    messages: -> Docs.find type:'message'