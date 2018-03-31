# loggedIn = FlowRouter.group
#     triggersEnter: [ ->
#         unless Meteor.loggingIn() or Meteor.userId()
#             route = FlowRouter.current()
#             unless route.route.name is 'login'
#                 Session.set 'redirectAfterLogin', route.path
#             FlowRouter.go ‘login’
#     ]

FlowRouter.route '/user/:username', 
    name: 'user_info'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_info'
            
FlowRouter.route '/user/:username/settings', action: (params) ->
    name: 'account_settings'
    BlazeLayout.render 'user_layout',
        user_main: 'view_account'
    

            
            
            
FlowRouter.route '/user/:username/comparison', 
    name: 'user_comparison'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_comparison'
            
FlowRouter.route '/user/:username/conversations', 
    name: 'user_conversations'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_conversations'
            
FlowRouter.route '/user/:username/social', 
    name: 'user_social'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_social'
            
FlowRouter.route '/user/:username/documents', 
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_documents'
            
FlowRouter.route '/user/:username/karma', 
    name: 'user_karma'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_karma'
            
FlowRouter.route '/user/:username/contact', 
    name: 'user_contact'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_contact'
            
FlowRouter.route '/user/:username/transactions', 
    name: 'user_transactions'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            user_main: 'user_transactions'
            
FlowRouter.route '/user/:username/dashboard', 
    name: 'user_dashboard'
    action: ->
        BlazeLayout.render 'user_layout', 
            user_main: 'user_dashboard'

# FlowRouter.route '/dashboard',
#     triggersEnter: [ (context, redirect) ->
#         redirect "/user/#{Meteor.user().username}/dashboard"
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
    user: -> Meteor.users.findOne username: FlowRouter.getParam('username')

Template.user_layout.helpers
    
    user_docs: ->
        person = Meteor.users.findOne username:FlowRouter.getParam('username')
        Docs.find
            author_id:person._id
    
    is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
Template.user_layout.events
    'click #logout': -> AccountsTemplates.logout()



FlowRouter.route '/user/:username/docs', 
    name: 'user_docs'
    action: (params) ->
        BlazeLayout.render 'user_layout',
            # sub_nav: 'member_nav'
            user_main: 'profile_docs'



Template.profile_docs.onCreated -> 
    # @autorun => Meteor.subscribe('user_docs', FlowRouter.getParam('username'), selected_theme_tags.array())
    @autorun => Meteor.subscribe('user_docs', FlowRouter.getParam('username'))


Template.profile_docs.helpers
    user: -> Meteor.users.findOne username: FlowRouter.getParam('username')

    user_docs: -> 
        user = Meteor.users.findOne username: FlowRouter.getParam('username')
        Docs.find {
            published: 1
            author_id: user._id
            }, timestamp: -1
            
            
            
Template.user_contact.events
    'click #send_message': ->
        message = $('#message_area').val()
        Meteor.call 'send_message', FlowRouter.getParam('username'), message