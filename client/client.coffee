import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


Session.setDefault 'delta_id', null
Session.setDefault 'loading', false

Template.registerHelper 'session_delta_id', () -> 
    did = Session.get 'delta_id'
    console.log did
    did

Template.registerHelper 'site_stat', ->
    Docs.findOne
        type:'stat'


Template.registerHelper 'delta_doc', () -> 
    Docs.findOne Session.get('delta_id')

Template.registerHelper 'is_loading', () -> 
    Session.equals 'loading', true

Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  
    Meteor.userId() is @author_id

Template.registerHelper 'can_edit', () ->
    if Meteor.user()
        if Meteor.user().roles
            if 'dev' in Meteor.user().roles
                return true 
        else if Meteor.userId() is @author_id
            true

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
    
    
Template.registerHelper 'is_dev', ()->
    if Meteor.user()
        if Meteor.user().roles
            if 'dev' in Meteor.user().roles
                return true 
            

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.registerHelper 'brick_value', () -> 
    # console.log @
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

    

Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'stats'
    
    
    
    
FlowRouter.route '/',
    name: 'home'
    action: -> 
        if Meteor.userId()
            FlowRouter.go '/delta'
        else
            FlowRouter.go '/delta'

FlowRouter.route '/enter',
    name: 'enter'
    action: -> @render 'layout','enter'


FlowRouter.route '/me',
    name: 'me'
    action: -> @render 'layout','me'
FlowRouter.route '/settings',
    name: 'settings'
    action: -> @render 'layout','settings'

FlowRouter.route '/delta',
    name: 'delta'
    action: -> @render 'layout','delta'
FlowRouter.route '/chat',
    name: 'chat'
    action: -> @render 'layout','chat'

FlowRouter.route '/karma',
    name: 'karma'
    action: -> @render 'layout','karma'

FlowRouter.route '/users',
    name: 'users'
    action: -> @render 'layout','users'

FlowRouter.route '/mail',
    name: 'mail'
    action: -> @render 'layout','mail'
FlowRouter.route '/alerts',
    name: 'alerts'
    action: -> @render 'layout','alerts'

FlowRouter.route '/u/:username',
    name: 'user'
    action: -> @render 'layout','user'

 
FlowRouter.route '/edit/:doc_id',
    name: 'edit'
    action: -> @render 'layout','edit'

 
 
FlowRouter.route '/view/:doc_id',
    name: 'view_doc'
    action: -> @render 'layout','view'

 
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
        console.log 'calling fum', Session.get('delta_id')
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
        

