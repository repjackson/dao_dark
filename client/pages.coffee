import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.tasks.onCreated ->
        @autorun => Meteor.subscribe 'type', 'task'
    Template.tasks.events
    Template.tasks.helpers
        tasks: -> Docs.find type:'task'
        
        
        
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
        
        
        
        
        