import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'me'

FlowRouter.route '/',
    name: 'home'
    action: -> @render 'layout','delta'

FlowRouter.route '/enter',
    name: 'enter'
    action: -> @render 'layout','enter'

FlowRouter.route '/parse',
    name: 'parse'
    action: -> @render 'layout','parse'


FlowRouter.route '/me',
    name: 'me'
    action: -> @render 'layout','me'

FlowRouter.route '/d/:type',
    name: 'delta'
    action: -> @render 'layout','delta'

 
FlowRouter.route '/edit/:doc_id',
    name: 'edit_doc'
    action: -> @render 'layout','edit'

 
FlowRouter.route '/view/:doc_id',
    name: 'view_doc'
    action: -> @render 'layout','view'

 
Template.layout.events
    'click .create_delta': (e,t)->
        
    'click .logout': ->
        Meteor.logout()
        
    'click .delete_delta': (e,t)->
        delta = Docs.findOne _type:'delta'
        if delta
            Docs.remove delta._id

    'click .reset': (e,t)->
        # delta = Docs.findOne _type:'delta'
        Meteor.call 'fum'
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne _type:'delta'
        console.log delta

    'click .recalc': ->
        Meteor.call 'fum', (err,res)->

    'blur .delta_title': (e,t)->
        title_val = t.$('.delta_title').val()
        Docs.update Meteor.user().current_delta_id,
            $set: title: title_val
        


