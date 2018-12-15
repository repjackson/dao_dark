Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'

Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()

Template.registerHelper 'current_delta_id', ->
    Session.get 'current_delta_id'


Template.registerHelper 'is_current_delta', ->
    Session.equals 'current_delta_id', @_id

Template.registerHelper 'calculated_size', (input)->
    whole = parseInt input*10
    "f#{whole}"
    

        
Template.registerHelper 'is_full', ->
    delta = Docs.findOne Session.get('current_delta_id')
    if delta.total is 1 then true else false

Template.registerHelper 'is_half', ->
    delta = Docs.findOne Session.get('current_delta_id')
    if delta.total is 2 then true else false

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.registerHelper 'field_value', () -> 
    parent =  Template.parentData(5)
    if parent["#{@slug}"]
        parent["#{@slug}"]



Template.registerHelper 'current_delta', () -> 
    # if Meteor.user() and Meteor.user().current_delta_id
    #     delta = Docs.findOne Meteor.user().current_delta_id
    Docs.findOne Session.get('current_delta_id')


