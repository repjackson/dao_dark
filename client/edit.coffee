FlowRouter.route '/edit/:doc_id',
    name:'edit'
    action: ->
        BlazeLayout.render 'layout',
            main: 'edit'


Template.edit.onCreated ->
    @autorun => Meteor.subscribe 'single_doc', FlowRouter.getParam('doc_id')
    
Template.edit.helpers
    doc: ->
        Docs.findOne FlowRouter.getParam('doc_id')
        
        
Template.edit.events
    'blur .title': (e,t)->
        val = t.$('.title').val()
        console.log val
        Docs.update FlowRouter.getParam('doc_id'),
            $set: title:val
    'blur .content': (e,t)->
        val = t.$('.content').val()
        console.log val
        Docs.update FlowRouter.getParam('doc_id'),
            $set: content:val
    'keyup #add_tag': (e,t)->
        if e.which is 13
            val = t.$('#add_tag').val()
            console.log val
            Docs.update FlowRouter.getParam('doc_id'),
                $addToSet: tags:val
        
    'click .remove_tag': (e,t)->
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: @valueOf()