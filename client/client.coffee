@selected_tags = new ReactiveArray []


Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
Template.registerHelper 'person', () -> Meteor.users.findOne username:FlowRouter.getParam('username')

# Accounts.ui.config
#     passwordSignupFields: 'USERNAME_ONLY'

# Meteor.startup ->
#     Status.setTemplate('semantic_ui')

Template.staus_indicator.helpers
    labelClass: ->
        if @status?.idle
            'yellow'
        else if @status?.online
            'green'
        else
            'basic'

    online: ->  @status?.online
    
    idle: ->  @status?.idle







Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'user', Meteor.userId()


Template.nav.events
    'click #logout': -> AccountsTemplates.logout()


Template.tags.helpers
    tags: ->
        doc_count = Docs.find({}).count()
        # if selected_tags.array().length
        if 0 < doc_count < 3
            Tags.find { 
                # type:Template.currentData().type
                count: $lt: doc_count
                }, limit: 40
        else
            Tags.find({}, limit: 40)
            
            
    
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

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_tags.pop()
                    
Template.home.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_tags.array()
            )
        Meteor.subscribe 'doc', Session.get('editing_id')

Template.home.helpers
    one_doc: ->
        Docs.find().count() is 1

    docs: -> 
        if Session.get 'editing_id'
            Docs.find Session.get('editing_id')
        else
            Docs.find({},{limit:5,sort:tag_count:1})

    editing_this: -> Session.equals 'editing_id', @_id

    is_editing: -> Session.get 'editing_id'



Template.nav.events
    'click #add_doc': ->
        new_id = Docs.insert {}
        FlowRouter.go "/edit/#{new_id}"
        
    'keyup #quick_add': (e,t)->
        e.preventDefault
        tags = $('#quick_add').val().toLowerCase()
        if e.which is 13
            if tags.length > 0
                split_tags = tags.match(/\S+/g)
                # split_tags = tags.split(',')
                $('#quick_add').val('')
                Docs.insert
                    tags: split_tags
                selected_tags.clear()
                for tag in split_tags
                    selected_tags.push tag


        
        
