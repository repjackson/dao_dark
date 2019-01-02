Template.delta.onCreated ->


Template.delta.helpers
    current_delta: -> 
        Docs.findOne
            type:'delta'


Template.delta.events
    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag = t.$('.new_tag').val()    
            # Meteor.call 'pull_subreddit', subreddit
            # console.log @
            Docs.update @_id,
                $addToSet: tags: tag
            t.$('.new_tag').val('')    
                
                
    'click .new_temp_session': ->
        console.log @
        new_delta = Docs.insert type:'delta'
        Session.set 'delta_id', new_delta
        Meteor.call 'fum', Session.get('delta_id')



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



Template.delta.events
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
      
    'keyup .add_filter': (e,t)->
        if e.which is 13
            delta = Docs.findOne type:'delta'
            concept = t.$('.add_filter').val()
            Meteor.call 'add_facet_filter', delta._id, 'concepts', concept, ->
                Session.set 'loading', false
            concept = t.$('.add_filter').val('')
            
        
      
    
Template.delta.helpers
    filtering_res: ->
        delta = Docs.findOne type:'delta'
        filtering_res = []
        for filter in @facet_out
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @facet_in
                filtering_res.push filter
        filtering_res

    

    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne type:'delta'
        if Session.equals 'loading', true
             'disabled '
        else ''
    
    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id

    
Template.result.helpers
    result: -> Docs.findOne @_id
    
    
    
    