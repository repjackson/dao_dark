FlowRouter.route '/', 
    action: ->
        BlazeLayout.render 'layout', 
            main: 'library'



Template.tags.helpers
    tags: ->
        doc_count = Docs.find({}).count()
        # if selected_tags.array().length
        if 1 < doc_count < 3
            Tags.find { 
                # type:Template.currentData().type
                count: $lt: doc_count
                }, limit: 42
        else
            Tags.find({}, limit: 42)
            
            
    
    tag_class: ->
        doc_count = Docs.find({}).count()
        # if selected_tags.array().length
        # if doc_count < 3
        #     if @count is 1 then 'disabled'
        # if doc_count is 1 then 'disabled' else ''
        if doc_count is 1
            'disabled'
        else
            button_class = []
            switch
                when @index <= 10 then button_class.push 'large'
                when @index <= 30 then button_class.push ''
                when @index <= 50 then button_class.push 'small'
                when @index <= 80 then button_class.push 'small '
                when @index <= 100 then button_class.push 'tiny'
            return button_class
        

    selected_tags: -> selected_tags.array()

Template.tags.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()


Template.view_toggle.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        console.log @name


Template.library.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_tags.array()
            )
        Meteor.subscribe 'doc', Session.get('editing_id')

Template.library.helpers
    one_doc: -> Docs.find().count() is 1

    viewing_table: -> Session.equals 'view_mode','table'

    docs: -> Docs.find({},{limit:1,sort:tag_count:1})
Template.table_view.helpers
    table_docs: -> Docs.find({},{limit:10,sort:tag_count:1})

    # editing_this: -> Session.equals 'editing_id', @_id

    # is_editing: -> Session.get 'editing_id'

