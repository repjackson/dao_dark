Template.root.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'public_deltas'


Template.root.events
    'click .create_delta': (e,t)->
        Meteor.call 'create_delta', (err,res)->
            Session.set 'current_delta_id', res
        Meteor.call 'fo', Session.get('current_delta_id')
        
    'click .select_delta': ->
        Session.set 'current_delta_id', @_id
        if Meteor.user()
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_delta_id: @_id
                    current_template: 'delta'
        Meteor.call 'fo', Session.get('current_delta_id')
        
    'click .logout': ->
        Meteor.logout()
        
        
Template.root.helpers
    page: ->
        if Meteor.user()
            if Meteor.user().page then Meteor.user().page
            else 'delta'
        else
            'front'


Template.delta.helpers
    card_number: ->
        delta = Docs.findOne Session.get('current_delta_id')
        if delta
            switch delta.total
                when 1 then 'one'
                # when 2 then 'two'
                # when 3 then 'three'
                else 'one'
        
    public_sessions: ->
        Docs.find
            schema:'delta'
            author_id:$exists:'false'

    delta_selector_class: ->
        if Session.equals('current_delta_id', @_id) then 'black' else ''

 
 
Template.root.events
    'click .delete_delta': (e,t)->
        # delta = Docs.findOne Session.get('current_delta_id')
        delta = Docs.findOne Session.get('current_delta_id')
        
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne Session.get('current_delta_id')
        console.log delta

    'click .recalc': ->
        Meteor.call 'fo', (err,res)->

    'blur .delta_title': (e,t)->
        title_val = t.$('.delta_title').val()
        Docs.update Meteor.user().current_delta_id,
            $set: title: title_val
        

Template.facet.helpers
    filtering_res: ->
        delta = Docs.findOne Session.get('current_delta_id')
        filtering_res = []
        for filter in @res
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @filters
                filtering_res.push filter
        filtering_res

    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne Session.get('current_delta_id')

        if facet.filters and @name in facet.filters
            'grey'
        else
            ''

Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne Session.get('current_delta_id')
        facet = Template.currentData()
        
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
      

