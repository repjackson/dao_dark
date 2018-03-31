FlowRouter.route '/admin', 
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'admin'



    
Template.admin.onRendered ->
    @autorun => Meteor.subscribe 'admin'
    

Template.block_page.onCreated ->
    @autorun => Meteor.subscribe 'block', FlowRouter.getParam('hash')
    

Template.block_page.helpers
    block: -> Docs.findOne type:'block'
        