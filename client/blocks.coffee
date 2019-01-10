Template.comments.onCreated ->
    @autorun => Meteor.subscribe 'children', 'comment', FlowRouter.getParam('doc_id')

Template.comments.helpers
    doc_comments: ->
        Docs.find
            type:'comment'

Template.comments.events
    'keyup .add_comment': (e,t)->
        if e.which is 13
            parent = Docs.findOne FlowRouter.getParam('doc_id')
            comment = t.$('.add_comment').val()
            console.log comment
            Docs.insert
                parent_id: FlowRouter.getParam('doc_id')
                type:'comment'
                body:comment
            t.$('.add_comment').val('')
            

Template.user_info.onCreated ->
    @autorun => Meteor.subscribe 'user', @data

Template.user_info.helpers
    user: -> 
        console.log @
        Meteor.users.findOne @valueOf()