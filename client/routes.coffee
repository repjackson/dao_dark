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

FlowRouter.route '/delta',
    name: 'delta'
    action: -> @render 'layout','delta'

FlowRouter.route '/karma',
    name: 'karma'
    action: -> @render 'layout','karma'
FlowRouter.route '/mail',
    name: 'mail'
    action: -> @render 'layout','mail'
FlowRouter.route '/alerts',
    name: 'alerts'
    action: -> @render 'layout','alerts'

FlowRouter.route '/u/:username',
    name: 'profile'
    action: -> @render 'layout','profile'

 
FlowRouter.route '/edit/:doc_id',
    name: 'edit'
    action: -> @render 'layout','edit'

 
 
FlowRouter.route '/view/:doc_id',
    name: 'view_doc'
    action: -> @render 'layout','doc_page'

