import { FlowRouter } from 'meteor/ostrio:flow-router-extra'



Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'doc', Session.get('delta_id')
    @autorun -> Meteor.subscribe 'deltas'


Template.delta.helpers
    filtering_res: ->
        delta = Docs.findOne type:'delta'
        filtering_res = []
        for filter in @facet_out
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @facet_in
                filtering_res.push filter
        console.log filtering_res
        filtering_res

    

    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne type:'delta'
        if Session.equals 'loading', true
             'disabled '
        else ''
        
    current_delta: -> 
        Docs.findOne Session.get('delta_id')

    session_selector_class: ->
        if @_id is Session.get('delta_id') then 'grey' else ''

    public_sessions: ->
        Docs.find
            type:'delta'

    my_sessions: ->
        Docs.find
            type:'delta'

Template.delta.events
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

    'click .new_session': ->
        new_delta = 
            Docs.insert 
                type:'delta'
                title:'root'
                facets: [
                    {
                        key:'bricks'
                        filters:[]
                        res:[]
                    }
                    {
                        key:'_timestamp_tags'
                        filters:[]
                        res:[]
                    }
                    {
                        key:'_author_username'
                        filters:[]
                        res:[]
                    }
                ]
        
        # console.log new_delta
        Session.set('delta_id', new_delta)
        Meteor.call 'fum', Session.get('delta_id')
        
    'click .select_session': ->
        # console.log @
        Session.set 'delta_id', @_id


Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne Session.get('delta_id')
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
            delta = Docs.findOne Session.get('delta_id')
            facet = Template.currentData()
            filter = t.$('.add_filter').val()
            Session.set 'loading', true
            Meteor.call 'add_facet_filter', delta._id, facet.key, filter, ->
                Session.set 'loading', false
            t.$('.add_filter').val('')
            
        
      
    
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
             'disabled '
        else if facet.filters.length > 0 and @name in facet.filters
            'grey'
        else ''
        
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id

Template.result.helpers
    result: -> Docs.findOne @_id