Session.setDefault 'loading', false
Session.setDefault 'did', null


Template.registerHelper 'calculated_size', (input)->
    whole = parseInt input*10
    "f#{whole}"

Template.registerHelper 'dev', () -> Meteor.isDevelopment


Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'delta'


Template.delta.helpers
    sessions: -> Docs.find type:'delta'
    
    session_selector_class: -> if @_id is Session.get('did') then 'active' else ''
    
    delta: -> Docs.findOne Session.get('did')
    loading: -> Session.get 'loading'
            
            

Template.delta.events
    'click .delete_delta': (e,t)->
        Docs.remove @_id

    'click .select_session': ->
        Session.set 'did', @_id

    'click .new_session': ->
        new_delta = 
            Docs.insert 
                type:'delta'
                facets: [
                    {
                        key:'tags'
                        filters:[]
                        res:[]
                    }
                ]
        Session.set 'did', new_delta
        Meteor.call 'fum', new_delta


Template.view.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id


    
Template.view.helpers
    result: -> 
        doc = Docs.findOne @_id
        # console.log doc
        doc
    
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



Template.view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.embed').embed()
            , 500

Template.view.events
    'blur .youtube_id': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.youtube_id').val()
        Docs.update parent._id, 
            $set:youtube_id:val
    'click .print': (e,t)->
        console.log Docs.findOne Session.get('page_data')
    
    'keyup .new_tag': (e,t)->
        if e.which is 13
            console.log @
            tag_val = t.$('.new_tag').val().toLowerCase().trim()
            Docs.update @_id, 
                $addToSet: tags: tag_val
            t.$('.new_tag').val('')
        
    'click .remove_tag': (e,t)->
        tag = @valueOf()
        result_id = Template.currentData()
        Docs.update result_id, 
            $pull:tags:tag
        t.$('.new_tag').val(tag)
        
    'blur .edit_body': (e,t)->
        body_val = t.$('.edit_body').val()
        parent = Docs.findOne Session.get('page_data')
        Docs.update parent._id, 
            $set: body:body_val
            
    'click .remove_doc': ->
        current_id = Template.currentData()._id
        Docs.remove current_id,
            