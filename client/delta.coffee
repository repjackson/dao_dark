Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'my_deltas'
Template.result.onCreated ->
    delta = Docs.findOne Meteor.user().current_delta_id
    if delta
        @autorun -> Meteor.subscribe 'doc_id', delta.doc_id
 
 
 
 Template.delta.events
    'click .delete_delta': (e,t)->
        delta = Docs.findOne Meteor.user().current_delta_id
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne Meteor.user().current_delta_id

    'click .recalc': ->
        Meteor.call 'fo', (err,res)->

    'blur .delta_title': (e,t)->
        title_val = t.$('.delta_title').val()
        Docs.update Meteor.user().current_delta_id,
            $set: title: title_val
        
 
 Template.delta.helpers       
    delta: -> 
        if Meteor.user()
            Docs.findOne Meteor.user().current_delta_id
    

Template.result.events
    'click .edit': ->
        Docs.update Meteor.user().current_delta_id,
            $set:
                editing:true
                doc_id: @_id


Template.result.helpers
    value: ->
        filter = Template.parentData()
        filter["#{@key}"]

    is_html: -> @type is 'html'
    is_number: -> @type is 'number'
    is_array: -> @type is 'array'
    is_string: -> @type is 'string'



Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        facet = Template.currentData()
        
        delta = Docs.findOne Meteor.user().current_delta_id
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                
                
