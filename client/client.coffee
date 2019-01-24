@selected_tags = new ReactiveArray []
@results = new ReactiveArray []

# Template.registerHelper 'calculated_size', (input)->
#     whole = parseInt input*10
#     "f#{whole}"

Template.registerHelper 'dev', () -> Meteor.isDevelopment


Template.registerHelper 'doc', () -> Docs.findOne FlowRouter.getParam('doc_id')


Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.delta.onCreated ->
    @autorun -> Meteor.subscribe('tags', selected_tags.array())
    @autorun -> Meteor.subscribe('docs', selected_tags.array())


Template.delta.onRendered ->
    Meteor.setTimeout ->
        $('.ui.search').search({
            source: results.list()
        })
    , 1000

Template.delta.helpers
    tags: ->
        results = []
        for tag in Tags.find()
            results.push 
                title: tag.name
        console.log results
        results

    selected_tags: -> selected_tags.list()

    global_tags: ->
        doc_count = Docs.find().count()
        if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()

    docs: -> Docs.find {}, limit:1

    single_doc: ->
        count = Docs.find({}).count()
        if count is 1 then true else false
    
    
Template.delta.events
    'click .select_tag': -> selected_tags.push @title
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()
    'keyup #new_search': (e,t)->
        results.clear()
        for tag in Tags.find().fetch()
            results.push { title:tag.title }
        console.log results  
        results
        
    'keyup #search': (e,t)->
        switch e.which
            when 13
                if e.target.value is 'clear'
                    selected_tags.clear()
                    $('#search').val('')
                else
                    selected_tags.push e.target.value.toLowerCase().trim()
                    $('#search').val('')
            when 8
                if e.target.value is ''
                    selected_tags.pop()




    'click .insert': (e,t)->
        new_ytid = t.$('.new_ytid').val().trim()
        title = t.$('.new_tags').val().toLowerCase()
        # new_tags = t.$('.new_tags').val().toLowerCase().split(' ')
        Docs.insert
            timestamp:Date.now()
            youtube_id:new_ytid
            tags:[title]
        
        selected_tags.clear()
        selected_tags.push title
        # Meteor.call 'fum', did
        t.$('.new_ytid').val('')
        t.$('.new_body').val('')
        t.$('.new_tags').val('')



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
            
            
    'keyup .new_tag': (e,t)->
        if e.which is 13
            # console.log @
            tag_val = t.$('.new_tag').val().toLowerCase().trim()
            Docs.update @_id, 
                $addToSet: tags: tag_val
            t.$('.new_tag').val('')
    
    'keyup .new_list': (e,t)->
        if e.which is 13
            # console.log @
            list_val = t.$('.new_list').val().toLowerCase().trim().split(' ')
            Docs.update @_id, 
                $addToSet: tags: $each: list_val
            t.$('.new_list').val('')
        
    'click .remove_tag': (e,t)->
        tag = @valueOf()
        result= Template.currentData()
        Docs.update result._id, 
            $pull:tags:tag
        t.$('.new_tag').val(tag)
        

    'click .remove_doc': ->
        current_id = Template.currentData()._id
        Docs.remove current_id,
            