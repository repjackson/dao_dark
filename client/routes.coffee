import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


FlowRouter.route '/',
    name: 'home'
    action: -> 
        if Meteor.userId()
            FlowRouter.go '/delta'
        else
            FlowRouter.go '/delta'

FlowRouter.route '/enter',
    name: 'enter'
    action: -> @render 'layout','enter'


FlowRouter.route '/me',
    name: 'me'
    action: -> @render 'layout','me'
    
FlowRouter.route '/settings',
    name: 'settings'
    action: -> @render 'layout','settings'
FlowRouter.route '/users',
    name: 'users'
    action: -> @render 'layout','users'

FlowRouter.route '/d/:type',
    name: 'type'
    action: -> @render 'layout','type'

FlowRouter.route '/delta',
    name: 'delta'
    action: -> @render 'layout','delta'

FlowRouter.route '/karma',
    name: 'karma'
    action: -> @render 'layout','karma'

FlowRouter.route '/tasks',
    name: 'tasks'
    action: -> @render 'layout','tasks'

FlowRouter.route '/events',
    name: 'events'
    action: -> @render 'layout','events'

FlowRouter.route '/chat',
    name: 'chat'
    action: -> @render 'layout','chat'

FlowRouter.route '/karma',
    name: 'karma'
    action: -> @render 'layout','karma'

FlowRouter.route '/shop',
    name: 'shop'
    action: -> @render 'layout','shop'


FlowRouter.route '/inbox',
    name: 'inbox'
    action: -> @render 'layout','inbox'
FlowRouter.route '/alerts',
    name: 'alerts'
    action: -> @render 'layout','alerts'

FlowRouter.route '/u/:username',
    name: 'user'
    action: -> @render 'layout','user'

 
FlowRouter.route '/edit/:doc_id',
    name: 'edit'
    action: -> @render 'layout','edit'

 
 
FlowRouter.route '/view/:doc_id',
    name: 'view_doc'
    action: -> @render 'layout','doc_page'

