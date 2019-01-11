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
            
    filtering_res: ->
        delta = Docs.findOne Session.get('did')
        filtering_res = []
        for filter in @fout
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @fin
                filtering_res.push filter
        filtering_res

    
Template.delta.events
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

    'click .delete_delta': (e,t)->
        Docs.remove @_id

    'click .select_session': ->
        Session.set 'did', @_id


    'click .insert': ->
        new_ytid = t.$('.new_ytid').val()
        new_body = t.$('.new_body').val()
        new_tags = t.$('.new_tags').val()
        Docs.insert
            new_ytid:new_ytid
            new_body:new_body
            new_tags:new_tags
        did = Session.get('did')
        Docs.update did,
            $set:fin:new_tags
        Meteor.call 'fum', did

    'click .new_session': ->
        new_delta = 
            Docs.insert 
                type:'delta'
                fin:[]
        Session.set 'did', new_delta
        Meteor.call 'fum', new_delta


Template.view.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id


    
Template.view.helpers
    result: -> 
        doc = Docs.findOne @_id
        # console.log doc
        doc
    


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
            # console.log @
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
            