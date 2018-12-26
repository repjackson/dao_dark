import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


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
    
    
Template.registerHelper 'doc', ()->
    doc_id = FlowRouter.getParam('doc_id')
    Docs.findOne doc_id 


Template.registerHelper 'parent_doc', ()->
    Template.parentData(5)
    
    

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.registerHelper 'brick_value', () -> 
    console.log @
    parent =  Template.parentData(5)
    if parent["#{@valueOf()}"]
        # console.log parent["#{@valueOf()}"]
        parent["#{@valueOf()}"]

Template.registerHelper 'brick_meta', () -> 
    parent =  Template.parentData(5)
    if parent["_#{@valueOf()}"]
        # console.log parent["_#{@valueOf()}"]
        parent["_#{@valueOf()}"]

Template.registerHelper 'brick_key', () -> @valueOf()


Template.registerHelper 'value', () -> 
    parent =  Template.parentData()
    if parent["#{@key}"]
        parent["#{@key}"]

Template.registerHelper 'current_delta', () -> 
    # if Meteor.user() and Meteor.user().current_delta_id
    #     delta = Docs.findOne Meteor.user().current_delta_id
    Docs.findOne
        _type:'delta'
        _author_id:Meteor.userId()


