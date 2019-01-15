import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Session.setDefault 'invert', false


@selected_tags = new ReactiveArray []
@selected_usernames = new ReactiveArray []

# Template.registerHelper 'calculated_size', (input)->
#     whole = parseInt input*10
#     "f#{whole}"

Template.registerHelper 'dev', () -> Meteor.isDevelopment

Template.registerHelper 'dark_side', () -> Session.equals('invert',true)

Template.registerHelper 'doc', () -> Docs.findOne FlowRouter.getParam('doc_id')


Template.registerHelper 'invert_class', () -> if Session.equals('invert',true) then 'inverted' else ''

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.delta.onCreated ->
    @autorun -> Meteor.subscribe('tags', selected_tags.array(), selected_usernames.array())
    @autorun -> Meteor.subscribe('docs', selected_tags.array(), selected_usernames.array())

Template.delta.helpers
    selected_tags: -> selected_tags.list()

    global_tags: ->
        doccount = Docs.find().count()
        if 0 < doccount < 3 then Tags.find { count: $lt: doccount } else Tags.find()

    docs: -> Docs.find {}, limit:1

    single_doc: ->
        count = Docs.find({}).count()
        if count is 1 then true else false
    
    global_usernames: -> Usernames.find()
    selected_usernames: -> selected_usernames.list()

    
Template.delta.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()
    'keyup #search': (e)->
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
        new_body = t.$('.new_body').val().trim()
        title = t.$('.new_tags').val().toLowerCase()
        # new_tags = t.$('.new_tags').val().toLowerCase().split(' ')
        Docs.insert
            timestamp:Date.now()
            youtube_id:new_ytid
            body:new_body
            tags:[title]
        
        selected_tags.clear()
        selected_tags.push title
        # Meteor.call 'fum', did
        t.$('.new_ytid').val('')
        t.$('.new_body').val('')
        t.$('.new_tags').val('')



Template.view.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id
    Meteor.subscribe 'person', @author_id

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
        
    'blur .edit_body': (e,t)->
        body_val = t.$('.edit_body').val()
        console.log @
        Docs.update @_id, 
            $set: body:body_val
            
    'click .remove_doc': ->
        current_id = Template.currentData()._id
        Docs.remove current_id,
            
            
            
Template.layout.events
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
            
    'click .create_delta': (e,t)->
        
    'click .logout': ->
        Meteor.logout()
        
            