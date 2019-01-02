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
      
    'keyup .add_filter': (e,t)->
        if e.which is 13
            delta = Docs.findOne type:'delta'
            concept = t.$('.add_filter').val()
            Meteor.call 'add_facet_filter', delta._id, 'concepts', concept, ->
                Session.set 'loading', false
            concept = t.$('.add_filter').val('')
            
        
      
    
Template.facet.helpers
    filtering_res: ->
        delta = Docs.findOne type:'delta'
        filtering_res = []
        if @key is '_keys'
            filtered_list = [
                'entities'
                'keywords'
                'concepts'
                'tags'
                'youtube'
                'type'
            ]
            filtering_res = @res
            # for filter in @res
                # if filter.name in filtered_list then filtering_res.push filter
        else
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
             'disabled '
        else if facet.filters.length > 0 and @name in facet.filters
            'grey'
        else ''
    
    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id

    
Template.result.helpers
    result: -> Docs.findOne @_id
    
    
    
    