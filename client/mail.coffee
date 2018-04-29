Template.mail.onCreated ->
    @autorun => Meteor.subscribe('mail')

Template.mail.helpers
    messages: -> Docs.find type:'message'