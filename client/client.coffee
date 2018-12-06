Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'



Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
# Template.registerHelper 'person', () -> Meteor.users.findOne username:@username

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
# Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is @username

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")

Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()

Template.registerHelper 'detail_doc', (input) -> 
    delta = Docs.findOne type:'delta'
    if delta
        Docs.findOne delta.doc_id



Template.registerHelper 'my_deltas', () -> 
    Docs.find type:'delta'








Template.home.onCreated ->
    @autorun -> Meteor.subscribe 'my_deltas'
    delta = Docs.findOne type:'delta'
    if delta
        @autorun -> Meteor.subscribe 'doc_id', delta.doc_id

Template.edit.onCreated ->
    delta = Docs.findOne type:'delta'
    @autorun -> Meteor.subscribe 'doc_id', delta.doc_id

Template.result.onCreated ->
    delta = Docs.findOne type:'delta'
    if delta
        @autorun -> Meteor.subscribe 'doc_id', delta.doc_id

Template.home.helpers
    delta: -> 
        delta = Docs.findOne type:'delta'
        if delta 
            delta
    
    facets: ->
        # at least keys
        facets = []
        delta = Docs.findOne type:'delta'
        if delta 
            console.log delta
            if delta.keys_filter
                for item in delta.keys_filter
                    facets.push item.name
        facets.push 'keys'
        facets
    
Template.result.events
    'click .edit': ->
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:
                editing:true
                doc_id: @_id

    
Template.result.helpers
    value: ->
        filter = Template.parentData()
        filter["#{@key}"]

    is_html: -> @type is 'html'
    is_number: -> @type is 'number'
    is_string: -> @type is 'string'


Template.facet.helpers
    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne type:'delta'

        if facet.filters and @name in facet.filters
            'tc-button--cta'
        else
            'tc-button'

Template.edit.events
    'click .save': ->
        console.log @
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:
                editing:false
                result:@
    
    'click .detect_fields': ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne delta.doc_id
        Meteor.call 'detect_fields', editing_doc._id      
    
    
    'click .add_field': ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne delta.doc_id
        
        new_field = {
            label:'New Field'
            key:'new_field'
            type:'string'
            }    
    
        Docs.update delta.doc_id,
            $addToSet:
                fields: new_field
    
        
Template.edit.helpers
    editing_doc: ->
        delta = Docs.findOne type:'delta'
        doc = Docs.findOne delta.doc_id
        doc
    

Template.home.events
    'click .create_delta': (e,t)->
        Docs.insert
            type:'delta'
            facets: [{key:'keys', res:[]}]
            result_ids:[]
        # Meteor.call 'fo'
    
    'click .add_doc': ->
        delta = Docs.findOne type:'delta'
        new_id = Docs.insert {}
        new_doc = Docs.findOne new_id
        console.log new_doc
        Docs.update delta._id,
            $set:
                editing:true
                doc_id: new_id
    
    
    'click .delete_delta': (e,t)->
        delta = Docs.findOne type:'delta'
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne type:'delta'
        console.log delta

    'click .recalc': ->
        Meteor.call 'fo', (err,res)->


Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne type:'delta'
        facet = Template.currentData()
        
        delta = Docs.findOne type:'delta'
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                
                
                
Template.field.events
    'blur .label': (e,t)->
        delta = Docs.findOne type:'delta'
        doc = Docs.findOne delta.doc_id
        # val = 
        value = e.currentTarget.value
        Meteor.call 'update_field', delta.doc_id, @, 'label', value 
        
    'blur .value': ->
        console.log @
        
    'blur .key': ->
        console.log @
        
    'blur .type': ->
        console.log @
        
        
    'click .delete_field': ->
        # if confirm "Remove #{@label}?"
        delta = Docs.findOne type:'delta'
        doc = Docs.findOne delta.doc_id
        Docs.update delta.doc_id,
            $pull: fields: @
        
        