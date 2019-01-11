Session.setDefault 'loading', false
Session.setDefault 'page', 'delta'
Session.setDefault 'page_data', null
Session.setDefault 'did', null

Template.registerHelper 'messages', ()-> Docs.find type:'message'
Template.registerHelper 'alerts', ()-> Docs.find type:'alert'
Template.registerHelper 'users', ()-> Meteor.users.find {}
Template.registerHelper 'doc', ()-> Docs.findOne Session.get('page_data')

Template.registerHelper 'viewing_user', ()-> 
    Meteor.users.findOne username:Session.get('page_data')

Template.registerHelper 'calculated_size', (input)->
    whole = parseInt input*10
    "f#{whole}"


Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()



Template.registerHelper 'is_dev', ()->
    if Meteor.user()
        if Meteor.user().roles
            if 'dev' in Meteor.user().roles
                return true 


Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  
    Meteor.userId() is @author_id

Template.registerHelper 'can_edit', () ->
    if Meteor.user()
        if Meteor.user().roles
            if 'dev' in Meteor.user().roles
                return true 
        else if Meteor.userId() is @author_id
            true


Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'delta'
Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'users'
    @autorun -> Meteor.subscribe 'type', 'deltas'
    # @autorun -> Meteor.subscribe 'type', 'message'
    # @autorun -> Meteor.subscribe 'type', 'alert'

Template.layout.helpers
    main_template: -> Meteor.user().page

Template.sessions.helpers
    sessions: -> Docs.find type:'delta'
    
    session_selector_class: -> if @_id is Session.get('did') then 'active' else ''
    

Template.youtube_edit.events                
    'blur .youtube_id': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.youtube_id').val()
        Docs.update parent._id, 
            $set:youtube_id:val

Template.youtube_edit.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.embed').embed()
            , 500
Template.youtube_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.embed').embed()
            , 500



Template.sessions.events
    'click .delete_delta': (e,t)->
        Docs.remove @_id

    'click .select_session': ->
        Session.set 'did', @_id
        # Meteor.users.update Meteor.userId(), 
        #     $set: did: @_id

    'click .new_session': ->
        new_delta = 
            Docs.insert 
                type:'delta'
                title:'tab'
                facets: [
                    {
                        key:'tags'
                        filters:[]
                        res:[]
                    }
                ]
        # Meteor.users.update Meteor.userId(),
        #     $set: did: new_delta
        Session.set 'did', new_delta
        Meteor.call 'fum', new_delta


Template.delta.helpers
    delta: -> 
        Docs.findOne Session.get('did')
            
    loading: -> Session.get 'loading'

Template.view.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id

    
Template.view.helpers
    result: -> 
        doc = Docs.findOne @_id
        # console.log doc
        doc
    
Template.view.events
    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag = t.$('.new_tag').val().toLowerCase()   
            # Meteor.call 'pull_subreddit', subreddit
            if @tags
                tag_count = @tags.length
            else
                tag_count = 0
            Docs.update @_id,
                $addToSet: 
                    tags: tag
                $set:tag_count:tag_count
            t.$('.new_tag').val('')    
                
                
    'click .remove_tag': (e,t)->
        current_id = Template.currentData()._id
        new_tag_val = t.$('.new_tag').val()
        unless new_tag_val
            Docs.update current_id,
                $pull:tags:@valueOf()
            t.$('.new_tag').val(@valueOf())    
            
        
    
    'click .remove_doc': ->
        current_id = Template.currentData()._id
        Docs.remove current_id,
    

# Template.facet.onCreated ->
#     Meteor.setTimeout ->
#         $('.ui.accordion').accordion()
#     , 1000

    
Template.facet.helpers
    filtering_res: ->
        delta = Docs.findOne Session.get('did')
        filtering_res = []
        for filter in @res
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @filters
                filtering_res.push filter
        filtering_res

    
    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne Session.get('did')
        # if Session.equals 'loading', true
        #      'disabled '
        if facet.filters.length > 0 and @name in facet.filters
            'active'
        else ''


Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne Session.get('did')
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
            delta = Docs.findOne Session.get('did')
            facet = Template.currentData()
            new_filter = t.$('.add_filter').val()
            Meteor.call 'add_facet_filter', delta._id, facet.key, new_filter, ->
                Session.set 'loading', false
            concept = t.$('.add_filter').val('')
