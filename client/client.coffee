Session.setDefault 'delta_id', null
Session.setDefault 'loading', false

Template.registerHelper 'session_delta_id', () -> 
    did = Session.get 'delta_id'
    did

Template.registerHelper 'site_stat', ->
    Docs.findOne
        type:'stat'


Template.registerHelper 'delta_doc', () -> 
    Docs.findOne Session.get('delta_id')

Template.registerHelper 'is_loading', () -> 
    Session.equals 'loading', true

Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
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
    parent =  Template.parentData(5)
    if parent["#{@valueOf()}"]
        parent["#{@valueOf()}"]

Template.registerHelper 'brick_meta', () -> 
    parent =  Template.parentData(5)
    if parent["_#{@valueOf()}"]
        parent["_#{@valueOf()}"]

Template.registerHelper 'brick_key', () -> @valueOf()


Template.registerHelper 'value', () -> 
    parent =  Template.parentData()
    if parent["#{@key}"]
        parent["#{@key}"]

    

Template.layout.onCreated ->
    
    
    
    
Template.layout.events
    'click .refresh_stat': ->
        Meteor.call 'site_stat', ->
            
    'keyup #quick_add': (e,t)->
        if e.which is 13
            body = t.$('#quick_add').val()
            new_id = 
                Docs.insert
                    body:body
            FlowRouter.go "/edit/#{new_id}"
            t.$('#quick_add').val('')
        
Template.layout.onCreated ->
    
Template.layout.events
    'click .home': ->
        delta = Docs.findOne type:'delta'
        if delta
            Docs.remove delta._id
        Session.set 'delta_id', null
        
    'click .reset': ->    
        Meteor.call 'fum', Session.get('delta_id')
            
            
            
    'click .add': ->
        new_id = Docs.insert {}
        FlowRouter.go "/edit/#{new_id}"
            
    'click .logout': -> 
        Meteor.logout()
        FlowRouter.go "/enter"
            
    'click .create_delta': (e,t)->
        
    'click .logout': ->
        Meteor.logout()
        

