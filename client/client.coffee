Session.setDefault 'delta_id', null
Session.setDefault 'loading', false

Template.registerHelper 'session_delta_id', () -> 
    did = Session.get 'delta_id'
    did

Template.registerHelper 'delta_doc', () -> 
    Docs.findOne Session.get('delta_id')

Template.registerHelper 'is_loading', () -> 
    Session.equals 'loading', true

    
Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.layout.events
    'keyup #quick_add': (e,t)->
        if e.which is 13
            body = t.$('#quick_add').val()
            new_id = 
                Docs.insert
                    body:body
            console.log Docs.findOne new_id
            t.$('#quick_add').val('')
        

Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'delta', Session.get('delta_id')
    @autorun -> Meteor.subscribe 'deltas'


Template.layout.helpers
    current_delta: -> 
        Docs.findOne Session.get('delta_id')

    session_selector_class: ->
        if @_id is Session.get('delta_id') then 'grey' else ''

    sessions: ->
        Docs.find
            type:'delta'

Template.layout.events
    'click .delete_delta': (e,t)->
        delta = Docs.findOne Session.get('delta_id')
        if delta
            if confirm "delete  #{delta._id}?"
                Docs.remove delta._id

    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag = t.$('.new_tag').val()    
            # Meteor.call 'pull_subreddit', subreddit
            Docs.update @_id,
                $addToSet: tags: tag
            t.$('.new_tag').val('')    
                
                
    'click .new_session': ->
        new_delta = 
            Docs.insert 
                type:'delta'
                fi:[]
        Session.set('delta_id', new_delta)
        Meteor.call 'fum', Session.get('delta_id')
    

    'click .add_filter': ->
        did = Session.get('delta_id')
        delta = Docs.findOne did
        Session.set 'loading', true
        Docs.update did, $addToSet: fi: @name
        Meteor.call 'fum', did, (err,res)->
            Session.set 'loading', false
    
    'click .pull_filter': ->
        did = Session.get('delta_id')
        Session.set 'loading', true
        Docs.update did, $pull: fi: @valueOf()
        Meteor.call 'fum', did, (err,res)->
            Session.set 'loading', false
      
    'keyup #add_filter': (e,t)->
        if e.which is 13
            did = Session.get('delta_id')
            delta = Docs.findOne type:'delta'
            tag = t.$('.add_filter').val()
            Docs.update did, $addToSet: fi:tag
            Meteor.call 'fum', did, (err,res)->
                t.$('.add_filter').val('')
                Session.set 'loading', false
            
    'click .select_session': ->
        Session.set 'delta_id', @_id


    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id

    
Template.result.helpers
    result: -> Docs.findOne @_id
    
    
    
# Template.facet.events
#     'click .toggle_selection': ->
#         delta = Docs.findOne Session.get('delta_id')
#         facet = Template.currentData()
#         Session.set 'loading', true
#         if facet.filters and @name in facet.filters
#             Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
#                 Session.set 'loading', false
#         else 
#             Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
#                 Session.set 'loading', false
      
#     'keyup .add_filter': (e,t)->
#         if e.which is 13
#             delta = Docs.findOne Session.get('delta_id')
#             concept = t.$('.add_filter').val()
#             Meteor.call 'add_facet_filter', delta._id, 'concepts', concept, ->
#                 Session.set 'loading', false
#             concept = t.$('.add_filter').val('')
            
        
      
    
Template.layout.helpers
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
    
    