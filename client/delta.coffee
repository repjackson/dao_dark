import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'delta', Session.get('delta_id')
    @autorun -> Meteor.subscribe 'deltas'


Template.delta.helpers
    current_delta: -> 
        Docs.findOne
            type:'delta'

    public_sessions: ->
        Docs.find
            type:'delta'

    my_sessions: ->
        Docs.find
            type:'delta'


Template.nav.events
    'click .create_delta': (e,t)->
        
    'click .logout': ->
        Meteor.logout()
        
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



    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag = t.$('.new_tag').val()    
            # Meteor.call 'pull_subreddit', subreddit
            # console.log @
            Docs.update @_id,
                $addToSet: tags: tag
            t.$('.new_tag').val('')    
                
                
    'click .new_session': ->
        new_delta = Docs.insert type:'delta'
        
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


    'click .home': ->
        delta = Docs.findOne type:'delta'
        if delta
            Docs.remove delta._id
        Session.set 'delta_id', null
        
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
    
    
    
    