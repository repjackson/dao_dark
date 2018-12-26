Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'delta'


Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne _type:'delta'
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
        delta = Docs.findOne _type:'delta'
        filtering_res = []
        for filter in @res
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @filters
                filtering_res.push filter
        filtering_res

    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne _type:'delta'
        if Session.equals 'loading', true
             'disabled'
        else
            if facet.filters.length > 0 and @name in facet.filters
                'grey'
    
    
    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id

    
Template.result.helpers
    result: -> Docs.findOne @_id
    
    
Template.result.events
    'click .detect_fields': ->
        console.log @
        Meteor.call 'detect_fields', @_id
    
    
    