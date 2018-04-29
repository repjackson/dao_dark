# Template.user_layout.onCreated ->
#     @autorun -> Meteor.subscribe('user_profile', @username)
#     # @autorun -> Meteor.subscribe('ancestor_id_docs', null, @username)
#     # @autorun -> Meteor.subscribe('ancestor_ids', null, @username)

    
# # Template.user_layout.onRendered ->
# #     Meteor.setTimeout =>
# #         $('.menu .item').tab()
# #     , 1000


# Template.user_info.helpers
#     user: -> Meteor.users.findOne username: @username

# Template.user_layout.helpers
#     # user_docs: ->
#     #     person = Meteor.users.findOne username:@username
#     #     Docs.find
#     #         author_id:person._id
    
#     is_user: -> @username is Meteor.user()?.username
    
    
# Template.user_layout.events
#     'click #logout': -> AccountsTemplates.logout()




# Template.profile_docs.onCreated -> 
#     # @autorun => Meteor.subscribe('user_docs', @username, selected_theme_tags.array())
#     @autorun => Meteor.subscribe('user_docs', @username)


# Template.profile_docs.helpers
#     user: -> Meteor.users.findOne username: @username

#     user_docs: -> 
#         user = Meteor.users.findOne username: @username
#         Docs.find {
#             published: 1
#             author_id: user._id
#             }, 
#                 sort:timestamp: -1
#                 limit: 5
            
            
# Template.user_contact.events
#     'click #send_message': ->
#         message = $('#message_area').val()
#         Meteor.call 'send_message', @username, message