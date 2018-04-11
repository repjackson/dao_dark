FlowRouter.route '/ads', 
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'ads'



    
Template.ads.onRendered ->
    @autorun => Meteor.subscribe 'ads'
    

Template.ad_page.onCreated ->
    @autorun => Meteor.subscribe 'block', FlowRouter.getParam('hash')
    

Template.ad_page.helpers
    ad: -> Docs.findOne type:'ad'
        
        