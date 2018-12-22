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
                'grey'
    
    
    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id
    # @autorun => Meteor.subscribe 'edit_doc_schema', @data._id
    # @autorun => Meteor.subscribe 'edit_doc_schema_fields', @data._id

    
Template.result.helpers
    result: -> Docs.findOne @_id

    result_schema: ->
        console.log @
        # doc_id = Template.currentData()._id
        # edit_doc = Docs.findOne doc_id 
        Docs.findOne
            type:'schema'
            slug: edit_doc.type
        
    result_schema_fields: ->
        schema = Docs.findOne
            type:'schema'
            slug: @type
        
        if schema
            Docs.find
                type:'field'
                parent_id:schema._id
                