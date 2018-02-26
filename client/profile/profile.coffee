# loggedIn = FlowRouter.group
#     triggersEnter: [ ->
#         unless Meteor.loggingIn() or Meteor.userId()
#             route = FlowRouter.current()
#             unless route.route.name is 'login'
#                 Session.set 'redirectAfterLogin', route.path
#             FlowRouter.go ‘login’
#     ]

FlowRouter.route '/u/:username', 
    name: 'user_info'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_info'
            
FlowRouter.route '/u/:username/settings', action: (params) ->
    name: 'account_settings'
    BlazeLayout.render 'user_layout',
        user_main: 'view_account'
    

            
            
            
FlowRouter.route '/u/:username/comparison', 
    name: 'user_comparison'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_comparison'
            
FlowRouter.route '/u/:username/conversations', 
    name: 'user_conversations'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_conversations'
            
FlowRouter.route '/u/:username/social', 
    name: 'user_social'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_social'
            
FlowRouter.route '/u/:username/documents', 
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_documents'
            
FlowRouter.route '/u/:username/karma', 
    name: 'user_karma'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_karma'
            
FlowRouter.route '/u/:username/contact', 
    name: 'user_contact'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_contact'
            
FlowRouter.route '/u/:username/dashboard', 
    name: 'user_dashboard'
    action: ->
        BlazeLayout.render 'user_layout', 
            user_main: 'user_dashboard'

# FlowRouter.route '/dashboard',
#     triggersEnter: [ (context, redirect) ->
#         redirect "/u/#{Meteor.user().username}/dashboard"
#         return
#     ]




Template.user_layout.onCreated ->
    @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))
    @autorun -> Meteor.subscribe('ancestor_id_docs', null, FlowRouter.getParam('username'))
    @autorun -> Meteor.subscribe('ancestor_ids', null, FlowRouter.getParam('username'))

    
# Template.user_layout.onRendered ->
#     Meteor.setTimeout =>
#         $('.menu .item').tab()
#     , 1000


Template.user_info.helpers

Template.user_layout.helpers
    
    user_docs: ->
        person = Meteor.users.findOne username:FlowRouter.getParam('username')
        Docs.find
            author_id:person._id
    
    is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
Template.user_layout.events
    'click #logout': -> AccountsTemplates.logout()
