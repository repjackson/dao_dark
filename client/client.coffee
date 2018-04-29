@selected_tags = new ReactiveArray []

# Template.registerHelper 'field_doc', ()-> 
#     Docs.findOne Template.parentData(1)


Template.registerHelper 'field_value', ->
    # console.log @
    current_doc = Template.parentData(3)
    # current_doc = Docs.findOne @doc_id
    if current_doc
        current_doc["#{@key}"]
        
Template.registerHelper 'page_field_value', ->
    # console.log @
    # current_doc = Template.parentData(3)
    current_doc = Docs.findOne @doc_id
    current_doc["#{@key}"]
        
Template.registerHelper 'passed_field_doc', ->
    field_doc = Docs.findOne @valueOf()
    # console.log 'passed_field_doc slug',field_doc.slug
    field_doc
    # current_doc = Docs.findOne @doc_id
    # current_doc["#{@key}"]


        
Template.registerHelper 'has_role', (role)-> Meteor.user().roles and role in Meteor.user().roles   

Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
# Template.registerHelper 'person', () -> Meteor.users.findOne username:@username

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
# Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is @username

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'admin_mode', () ->  Session.get 'admin_mode'
Template.registerHelper 'editing', () ->  Session.get('editing')
Template.registerHelper 'theme_tag_class': -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")

Template.registerHelper 'formatted_start_date', () -> moment(@start_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_end_date', () -> moment(@end_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'tag_class', ()-> if @valueOf() in selected_tags.array() then 'active' else ''
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev', () -> Meteor.isDevelopment


# Meteor.startup ->
#     Status.setTemplate('semantic_ui')

# Template.staus_indicator.helpers
#     labelClass: ->
#         if @status?.idle
#             'yellow'
#         else if @status?.online
#             'green'
#         else
#             'basic'

#     online: ->  @status?.online
    
#     idle: ->  @status?.idle



# FlowRouter.wait()
# Tracker.autorun ->
#   # if the roles subscription is ready, start routing
#   # there are specific cases that this reruns, so we also check
#   # that FlowRouter hasn't initalized already
#   if !FlowRouter._initialized
#      FlowRouter.initialize()





        
