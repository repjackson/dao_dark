import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'delta', Session.get('delta_id')
    @autorun -> Meteor.subscribe 'deltas'


Template.layout.helpers
    current_delta: -> 
        Docs.findOne Session.get('delta_id')

    session_selector_class: ->
        if @_id is Session.get('delta_id') then 'black' else ''

    public_sessions: ->
        Docs.find
            type:'delta'

    my_sessions: ->
        Docs.find
            type:'delta'


    session_label: ->
        console.log @

Template.layout.events
    'click .delete_delta': (e,t)->
        delta = Docs.findOne Session.get('delta_id')
        if delta
            if confirm "delete  #{delta._id}?"
                Docs.remove delta._id

    'click .print_delta': (e,t)->
        delta = Docs.findOne Session.get('delta_id')
        console.log delta

    'click .recalc': ->
        Meteor.call 'fum', (err,res)->

    'blur .delta_title': (e,t)->
        title_val = t.$('.delta_title').val()
        Docs.update Meteor.user().current_delta_id,
            $set: title: title_val



    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag = t.$('.new_tag').val()    
            # Meteor.call 'pull_subreddit', subreddit
            # console.log @
            Docs.update @_id,
                $addToSet: tags: tag
            t.$('.new_tag').val('')    
                
                
    'click .new_session': ->
        new_delta = 
            Docs.insert 
                type:'delta'
                title:'root'
                facets: [
                    {
                        key:'_keys'
                        filters:[]
                        res:[]
                    }
                ]
        
        console.log new_delta
        Session.set('delta_id', new_delta)
        Meteor.call 'fum', Session.get('delta_id')
    
    'click .new_journal': ->
        new_delta = 
            Docs.insert 
                type:'delta'
                title:'journal'
                facets: [
                    {
                        key:'tags'
                        filters:[]
                        res:[]
                    }
                    {
                        key:'type'
                        filters:[]
                        res:[]
                    }
                ]
        
        console.log new_delta
        Session.set('delta_id', new_delta)
        Meteor.call 'fum', Session.get('delta_id')

    'click .select_filter': ->
        did = Session.get('delta_id')
        delta = Docs.findOne did
        Session.set 'loading', true
        # console.log @
        Docs.update did, $addToSet: facet_in: @name
        Meteor.call 'fum', did, (err,res)->
            Session.set 'loading', false
    
    'click .pull_filter': ->
        # console.log @
        did = Session.get('delta_id')
        Session.set 'loading', true
        Docs.update did, $pull: facet_in: @valueOf()
        Meteor.call 'fum', did, (err,res)->
            Session.set 'loading', false
      
    'keyup #add_filter': (e,t)->
        if e.which is 13
            did = Session.get('delta_id')
            delta = Docs.findOne type:'delta'
            tag = t.$('.add_filter').val()
            Docs.update did, $addToSet: facet_in:tag
            Meteor.call 'fum', did, (err,res)->
                t.$('.add_filter').val('')
                Session.set 'loading', false
            
    'click .select_session': ->
        console.log @
        Session.set 'delta_id', @_id



                
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
    
    
    
Template.facet.onCreated ->
    Meteor.setTimeout ->
        $('.ui.accordion').accordion()
    , 1000

Template.result.onCreated ->
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
    
    