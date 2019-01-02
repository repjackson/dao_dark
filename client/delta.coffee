import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


Template.delta.onCreated ->


Template.delta.helpers
    current_delta: -> 
        Docs.findOne
            type:'delta'


Template.delta.events
    'click .create_delta': (e,t)->
        
    'click .logout': ->
        Meteor.logout()
        
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
                
                
    'click .new_temp_session': ->
        new_delta = Docs.insert type:'delta'
        
        console.log new_delta
        Session.set('delta_id', new_delta)
        Meteor.call 'fum', Session.get('delta_id')

    'click .toggle_selection': ->
        delta = Docs.findOne type:'delta'
        facet = Template.currentData()
        Session.set 'loading', true
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
                Session.set 'loading', false
            remove_facet_filter: (delta_id, key, filter)->
                Docs.update did, $pull: facet_in: filter
                Meteor.call 'fum', delta_id, (err,res)->
        else 
            did = Session.get('delta_id')
            Docs.update did, $addToSet: facet_in: filter
            Meteor.call 'fum', delta_id, (err,res)->
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                Session.set 'loading', false
      
    'keyup .add_filter': (e,t)->
        if e.which is 13
            delta = Docs.findOne type:'delta'
            concept = t.$('.add_filter').val()
            Meteor.call 'add_facet_filter', delta._id, 'concepts', concept, ->
                Session.set 'loading', false
            concept = t.$('.add_filter').val('')
            
        

Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'delta', Session.get('delta_id')


Template.delta.events
    'click .home': ->
        delta = Docs.findOne type:'delta'
        if delta
            Docs.remove delta._id
        new_delta_id = Docs.insert type:'delta'
        Session.set 'delta_id', new_delta_id
        
    'click .reset': ->    
        console.log 'calling fum', Session.get('delta_id')
        Meteor.call 'fum', Session.get('delta_id')
            
            
            
    'click .add': ->
        new_id = Docs.insert {}
        FlowRouter.go "/edit/#{new_id}"
            
    'click .logout': -> 
        Meteor.logout()
        FlowRouter.go "/enter"
            

                
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
    
    
    
    