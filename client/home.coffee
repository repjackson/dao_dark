
Template.home.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'my_delta'


Template.home.events
    'click .create_delta': (e,t)->
        new_delta_id = Docs.insert
            schema:'delta'
            facets: [
                {
                    key:'title'
                    filters: []
                    res:[]
                }
                {
                    key:'timestamp_tags'
                    filters: []
                    res:[]
                }
            ]
        Meteor.call 'fo'
        
    'click .select_delta': ->
        Meteor.users.update Meteor.userId(),
            $set: 
                current_delta_id: @_id
                current_template: 'delta'

    'click .logout': ->
        Meteor.logout()
        
        
Template.home.helpers
    one_result: ->
        delta = Docs.findOne schema:'delta'
        if delta
            if delta.total is 1 then true else false
        


Template.result.onCreated ->
    delta = Docs.findOne schema:'delta'
    if delta
        console.log delta
        @autorun -> Meteor.subscribe 'doc_id', delta.result_id
 
 
 
Template.home.events
    'click .delete_delta': (e,t)->
        # delta = Docs.findOne Meteor.user().current_delta_id
        delta = Docs.findOne schema:'delta'
        
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne Meteor.user().current_delta_id
        console.log delta

    'click .recalc': ->
        Meteor.call 'fo', (err,res)->

    'blur .delta_title': (e,t)->
        title_val = t.$('.delta_title').val()
        Docs.update Meteor.user().current_delta_id,
            $set: title: title_val
        
Template.result.onCreated ->
    Meteor.setTimeout ->
        $('.ui.progress').progress();
    , 500

Template.result.helpers
    value: ->
        filter = Template.parentData()
        filter["#{@key}"]


Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne schema:'delta'
        facet = Template.currentData()
        
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                
                
        