import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


Template.karma.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'product'


Template.karma.helpers
    products: ->
        Docs.find 
            type:'product'
            
            
Template.chat.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'chat'
            
Template.chat.helpers
    chats: -> 
        Docs.find
            type:'chat'
        
Template.chat.events
    'keyup .add_chat': (e,t)->
        if e.which is 13
            # parent = Docs.findOne FlowRouter.getParam('doc_id')
            chat = t.$('.add_chat').val()
            Docs.insert
                # parent_id: FlowRouter.getParam('doc_id')
                type:'chat'
                body:chat
            t.$('.add_chat').val('')
            