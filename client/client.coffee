@selected_tags = new ReactiveArray []

# Template.registerHelper 'field_doc', ()-> 
#     Docs.findOne Template.parentData(1)


Template.registerHelper 'page_field_value', ->
    # console.log @
    # current_doc = Template.parentData(3)
    current_doc = Docs.findOne FlowRouter.getParam('doc_id')
    current_doc["#{@key}"]


Template.registerHelper 'page_field_value', ->
    # console.log @
    # current_doc = Template.parentData(3)
    current_doc = Docs.findOne FlowRouter.getParam('doc_id')
    current_doc["#{@key}"]
        
Template.registerHelper 'has_role', (role)-> Meteor.user().roles and role in Meteor.user().roles   


Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
Template.registerHelper 'person', () -> Meteor.users.findOne username:FlowRouter.getParam('username')


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





        
