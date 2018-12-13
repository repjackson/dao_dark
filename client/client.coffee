Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'


Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()

        
Template.registerHelper 'field_value', () -> 
    parent =  Template.parentData(5)
    if parent["#{@slug}"]
        parent["#{@slug}"]



Template.registerHelper 'current_delta', () -> 
    if Meteor.user() and Meteor.user().current_delta_id
        delta = Docs.findOne Meteor.user().current_delta_id


Template.facet.helpers
    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne Meteor.user().current_delta_id

        if facet.filters and @name in facet.filters
            'grey'
        else
            ''