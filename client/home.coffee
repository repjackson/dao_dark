Template.home.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'public_deltas'


Template.home.events
    'click .create_delta': (e,t)->
        Meteor.call 'create_delta', (err,res)->
            Session.set 'current_delta_id', res
        Meteor.call 'fo'
        
    'click .select_delta': ->
        Session.set 'current_delta_id', @_id
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
        
    public_sessions: ->
        Docs.find
            schema:'delta'
            author_id:$exists:'false'

    delta_selector_class: ->
        if Session.equals('current_delta_id', @_id) then 'grey' else ''

Template.result.onCreated ->
    delta = Docs.findOne schema:'delta'
    if delta
        @autorun -> Meteor.subscribe 'doc_id', delta.result_id
 
 
 
Template.home.events
    'click .delete_delta': (e,t)->
        # delta = Docs.findOne Meteor.user().current_delta_id
        delta = Docs.findOne schema:'delta'
        
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne schema:'delta'
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

Template.facet.helpers
    filtering_res: ->
        delta = Docs.findOne schema:'delta'
        filtering_res = []
        for filter in @res
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @filters
                filtering_res.push filter
        filtering_res

Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne schema:'delta'
        facet = Template.currentData()
        
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                
                
        