
if Meteor.isClient
    Template.home.onCreated ->
        # @autorun -> Meteor.subscribe 'schema', Router.current().params.type
        # @autorun -> Meteor.subscribe 'type', 'person'
        # @autorun -> Meteor.subscribe 'tags', selected_tags.array(), Router.current().params.type
        # @autorun -> Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.type
        @autorun -> Meteor.subscribe 'schema_from_slug', Router.current().params.type
        @autorun -> Meteor.subscribe 'schema_bricks_from_slug', Router.current().params.type
        # @autorun -> Meteor.subscribe 'deltas', Router.current().params.type
        @autorun -> Meteor.subscribe 'my_delta'


    Template.home.helpers
        schema: ->
            Docs.findOne
                type:'schema'
                slug: Router.current().params.type

        type_docs: ->
            Docs.find
                type:Router.current().params.type

        selected_tags: -> selected_tags.list()

        grid_view_class: ->
            delta = Docs.findOne type:'delta'
            if delta.view_mode is 'grid' then 'delta_selected' else 'delta_selector'

        list_view_class: ->
            delta = Docs.findOne type:'delta'
            if delta.view_mode is 'list' then 'delta_selected' else 'delta_selector'

        table_view_class: ->
            delta = Docs.findOne type:'delta'
            if delta.view_mode is 'table' then 'delta_selected' else 'delta_selector'

        results_class: ->
            delta = Docs.findOne type:'delta'
            if delta.viewing_detail
                if delta.viewing_rightbar then 'twelve wide' else 'sixteen wide'
            else
            #     if delta.viewing_rightbar then 'nine wide' else 'twelve wide'
                'twelve wide'

        delta_left_column_class: ->
            delta = Docs.findOne type:'delta'
            if delta and delta.left_column_size
                switch delta.left_column_size
                    when 2 then 'two wide'
                    when 3 then 'three wide'
                    when 4 then 'four wide'
                    when 5 then 'five wide'
                    when 6 then 'six wide'
                    when 7 then 'seven wide'
                    when 8 then 'eight wide'
                    when 9 then 'nine wide'
                    when 10 then 'ten wide'
                    when 11 then 'eleven wide'
                    when 12 then 'twelve wide'
                    when 13 then 'thirteen wide'
                    when 14 then 'fourteen wide'
            else 'four wide'


        delta_right_column_class: ->
            delta = Docs.findOne type:'delta'
            if delta and delta.right_column_size
                switch delta.right_column_size
                    when 14 then 'fourteen wide'
                    when 13 then 'thirteen wide'
                    when 12 then 'twelve wide'
                    when 11 then 'eleven wide'
                    when 10 then 'ten wide'
                    when 9 then 'nine wide'
                    when 8 then 'eight wide'
                    when 7 then 'seven wide'
                    when 6 then 'six wide'
                    when 5 then 'five wide'
                    when 4 then 'four wide'
                    when 3 then 'three wide'
                    when 2 then 'two wide'
            else 'twelve wide'




        result_grid_class: ->
            delta = Docs.findOne type:'delta'
            if delta
                switch delta.total
                    when 2 then 'two column'
                    when 1 then 'one column'
                    else 'two column'


        current_delta: ->
            Docs.findOne type:'delta'


        global_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()

        single_doc: ->
            count = Docs.find({}).count()
            if count is 1 then true else false


    Template.set_page_size.helpers
        page_size_class: ->
            delta = Docs.findOne type:'delta'
            if delta and @value is delta.page_size then 'grey' else ''




    Template.set_page_size.events
        'click .set_page_size': (e,t)->
            delta = Docs.findOne type:'delta'
            Docs.update delta._id,
                $set:
                    current_page:0
                    skip_amount:0
                    page_size:@value
            Session.set 'loading', true
            Meteor.call 'fum', delta._id, ->
                Session.set 'loading', false




    Template.set_delta_key.helpers
        set_delta_key_class: ->
            delta = Docs.findOne type:'delta'
            if delta and delta["#{@key}"] is @value then 'grey' else ''



    Template.toggle_delta_config.helpers
        boolean_true: ->
            delta = Docs.findOne type:'delta'
            if delta then delta["#{@key}"]



    Template.toggle_delta_config.events
        'click .enable_key': ->
            delta = Docs.findOne type:'delta'
            Docs.update delta._id,
                $set:"#{@key}":true

        'click .disable_key': ->
            delta = Docs.findOne type:'delta'
            Docs.update delta._id,
                $set:"#{@key}":false



    Template.home.events
        'click .add_type_doc': ->
            current_type = Router.current().params.type
            current_schema = Docs.findOne
                type:'schema'
                slug:Router.current().params.type
            # console.log current_schema
            if current_schema.collection and current_schema.collection is 'users'
                new_username = prompt 'username'?
                if new_username
                    Meteor.call 'create_user_by_username', new_username, current_type,(err,res)->
                        Router.go "/s/#{Router.current().params.type}/#{res}/edit"
            else
                new_doc_id = Docs.insert
                    type:Router.current().params.type
                    parent_id: current_schema._id
                Router.go "/s/#{Router.current().params.type}/#{new_doc_id}/edit"

        'click .create_delta': (e,t)->
            Docs.insert
                type:'delta'

        'click .print_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            console.log delta

        'click .reset': ->
            delta = Docs.findOne type:'delta'
            console.log 'hi'
            Meteor.call 'fum', delta._id, (err,res)->

        'click .delete_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            if delta
                if confirm "delete  #{delta._id}?"
                    Docs.remove delta._id


        'click .page_up': (e,t)->
            delta = Docs.findOne type:'delta'
            Docs.update delta._id,
                $inc: current_page:1
            Session.set 'is_calculating', true
            Meteor.call 'fo', (err,res)->
                if err then console.log err
                else
                    Session.set 'is_calculating', false

        'click .page_down': (e,t)->
            delta = Docs.findOne type:'delta'
            Docs.update delta._id,
                $inc: current_page:-1
            Session.set 'is_calculating', true
            Meteor.call 'fo', (err,res)->
                if err then console.log err
                else
                    Session.set 'is_calculating', false


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
