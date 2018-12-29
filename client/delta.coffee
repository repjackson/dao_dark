Template.delta.onCreated ->


Template.delta.helpers
    current_delta: -> 
        Docs.findOne
            type:'delta'



Template.set_view_limit.helpers
    limit_class: ->
        delta = Docs.findOne type:'delta'
        if delta
            if @amount is delta._limit then 'grey large' else ''

Template.set_view_limit.events
    'click .set_limit': ->
        console.log @amount
        delta = Docs.findOne type:'delta'
        Docs.update delta._id, 
            $set:_limit: @amount
        Meteor.call 'fum'

Template.facet.onCreated ->
    Meteor.setTimeout ->
        $('.ui.accordion').accordion()
    , 1000



Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne type:'delta'
        facet = Template.currentData()
        Session.set 'loading', true
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
                Session.set 'loading', false
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                Session.set 'loading', false
      
    
Template.facet.helpers
    filtering_res: ->
        delta = Docs.findOne type:'delta'
        filtering_res = []
        for filter in @res
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @filters
                filtering_res.push filter
        filtering_res

    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne type:'delta'
        if Session.equals 'loading', true
             'disabled'
        else
            if facet.filters.length > 0 and @name in facet.filters
                'grey large'
    
    
    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id

    
Template.result.helpers
    result: -> Docs.findOne @_id
    
    
    
    