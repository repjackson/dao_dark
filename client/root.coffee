import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'stats'
    
    
    
    
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

FlowRouter.route '/delta',
    name: 'delta'
    action: -> @render 'layout','delta'

# FlowRouter.route '/d/:type',
#     name: 'delta'
#     action: -> @render 'layout','delta'

 
FlowRouter.route '/edit/:doc_id',
    name: 'edit_doc'
    action: -> @render 'layout','edit'

 
FlowRouter.route '/view/:doc_id',
    name: 'view_doc'
    action: -> @render 'layout','view'

 
Template.footer.events
    'click .refresh_stat': ->
        Meteor.call 'site_stat', ->
            
    'keyup #quick_add': (e,t)->
        if e.which is 13
            body = t.$('#quick_add').val()
            new_id = 
                Docs.insert
                    body:body
            FlowRouter.go "/edit/#{new_id}"
            t.$('#quick_add').val('')
        
Template.footer.onCreated ->
    
    