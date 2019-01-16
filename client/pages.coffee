import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


Template.type.helpers
    delta_type: -> FlowRouter.getParam('type')

Template.events.onCreated ->
    @autorun => Meteor.subscribe 'type', 'event'
Template.events.events
Template.events.helpers
    events: -> Docs.find type:'event'
    
    
Template.chat.onCreated ->
    @autorun => Meteor.subscribe 'type', 'chat'
Template.chat.events
Template.chat.helpers
    chats: -> Docs.find type:'chat'
    
    
        
        
        