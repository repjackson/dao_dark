FlowRouter.notFound =
    action: ->
        FlowRouter.go '/'


Template.registerHelper 'field_value', ->
    # console.log @
    current_doc = Template.parentData(3)
    # current_doc = Docs.findOne Session.get('editing_id')
    if current_doc
        current_doc["#{@key}"]
        
Template.registerHelper 'page_field_value', ->
    # console.log @
    # current_doc = Template.parentData(3)
    current_doc = Docs.findOne Session.get('editing_id')
    current_doc["#{@key}"]
        
Template.registerHelper 'passed_field_doc', ->
    field_doc = Docs.findOne @valueOf()
    # console.log 'passed_field_doc slug',field_doc.slug
    field_doc
    # current_doc = Docs.findOne Session.get('editing_id')
    # current_doc["#{@key}"]


Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
# Template.registerHelper 'person', () -> Meteor.users.findOne username:@username

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
# Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is @username

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")

Template.registerHelper 'formatted_start_date', () -> moment(@start_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_end_date', () -> moment(@end_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment
Template.registerHelper 'is_dev', () -> 
    user = Meteor.user()
    if user
        if Meteor.user().roles
            if 'dev' in Meteor.user().roles
                true
            else
                false
        else
            false
    else
        false

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()