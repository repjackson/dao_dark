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