Session.setDefault 'loading', false

Template.registerHelper 'is_loading', () -> 
    Session.equals 'loading', true

Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()

Template.registerHelper 'calculated_size', (input)->
    whole = parseInt input*10
    "f#{whole}"
    

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.registerHelper 'field_value', () -> 
    parent =  Template.parentData(5)
    if parent["#{@key}"]
        parent["#{@key}"]


Template.registerHelper 'value', () -> 
    parent =  Template.parentData()
    if parent["#{@key}"]
        parent["#{@key}"]

Template.registerHelper 'current_delta', () -> 
    # if Meteor.user() and Meteor.user().current_delta_id
    #     delta = Docs.findOne Meteor.user().current_delta_id
    Docs.findOne
        type:'delta'
        author_id:Meteor.userId()


