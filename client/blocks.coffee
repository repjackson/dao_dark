Template.comments.onCreated ->
    @autorun => Meteor.subscribe 'children'
Template.role_editor.onCreated ->
    @autorun => Meteor.subscribe 'type', 'role'

Template.comments.helpers
    doc_comments: ->
        Docs.find
            type:'comment'

Template.comments.events
    'keyup .add_comment': (e,t)->
        if e.which is 13
            parent = Docs.findOne Meteor.user().delta_id
            comment = t.$('.add_comment').val()
            console.log comment
            Docs.insert
                parent_id: Meteor.user().delta_id
                type:'comment'
                body:comment
            t.$('.add_comment').val('')
            

Template.user_info.onCreated ->
    @autorun => Meteor.subscribe 'user', @data

Template.user_info.helpers
    user: -> Meteor.users.findOne @valueOf()