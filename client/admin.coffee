Template.admin.onCreated ->
    @autorun => Meteor.subscribe('admin')

Template.admin.helpers
    messages: -> Docs.find type:'message'