import { FlowRouter } from 'meteor/ostrio:flow-router-extra';



Template.users.onCreated ->
    @autorun => Meteor.subscribe 'users'
    
    
Template.users.helpers
    users: -> 
        Meteor.users.find()        
    
Template.users.events
    'click .add_user': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'add_user'


Template.user.onCreated ->
    @autorun => Meteor.subscribe 'user', FlowRouter.getParam('username')
    
    
Template.user.helpers
    user: -> Meteor.users.findOne username:FlowRouter.getParam('username')
    