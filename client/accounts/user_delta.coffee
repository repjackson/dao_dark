if Meteor.isClient
    Template.user_delta.onCreated ->
        # @autorun -> Meteor.subscribe 'schema', Router.current().params.type
        # @autorun -> Meteor.subscribe 'type', 'person'
        # @autorun -> Meteor.subscribe 'tags', selected_tags.array(), Router.current().params.type
        # @autorun -> Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.type
        @autorun -> Meteor.subscribe 'schema_from_slug', Router.current().params.tribe_slug, Router.current().params.type
        @autorun -> Meteor.subscribe 'schema_bricks_from_slug', Router.current().params.tribe_slug, Router.current().params.type,true
        # @autorun -> Meteor.subscribe 'deltas', Router.current().params.type
        @autorun -> Meteor.subscribe 'my_delta'


    Template.user_delta.helpers
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




    Template.user_delta.events
        'click .add_type_doc': ->
            current_tribe = Docs.findOne
                type:'tribe'
                slug:Router.current().params.tribe_slug
            # console.log current_tribe
            new_doc_id = Docs.insert 
                type:Router.current().params.type
                parent_id: current_tribe._id
                tribe_id:current_tribe._id
                tribe:current_tribe.slug
            Router.go "/t/#{current_tribe.slug}/s/#{Router.current().params.type}/#{new_doc_id}/edit"

        'click .create_delta': (e,t)->
            Docs.insert 
                type:'delta'
                left_column_size: 6
                right_column_size: 10

        'click .print_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            console.log delta
    
        'click .reset': ->
            delta = Docs.findOne type:'delta'
            Meteor.call 'fum', delta._id, (err,res)->

        'click .edit_schema': ->
            schema = Docs.findOne
                type:'schema'
                slug: Router.current().params.type
            Router.go "/s/#{schema.slug}/#{schema._id}/edit"

        'click .delete_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            if delta
                if confirm "delete  #{delta._id}?"
                    Docs.remove delta._id

