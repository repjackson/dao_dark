# Router.route '/s/:type', -> @render 'type'
# Router.route '/s/:type/:id/edit', -> @render 'type_edit'
# Router.route '/s/:type/:id/view', -> @render 'type_view'


import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


if Meteor.isClient
    Template.type.onCreated ->
        # @autorun -> Meteor.subscribe 'schema', FlowRouter.getParam('type')
        # @autorun -> Meteor.subscribe 'type', 'schema'
        @autorun -> Meteor.subscribe 'tags', selected_tags.array(), FlowRouter.getParam('type')
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), FlowRouter.getParam('type')
        @autorun -> Meteor.subscribe 'schema_from_slug', FlowRouter.getParam('type')
        @autorun -> Meteor.subscribe 'schema_bricks_from_slug', FlowRouter.getParam('type')
        # @autorun -> Meteor.subscribe 'deltas', Router.current().params.type
        # @autorun -> Meteor.subscribe 'type', 'delta'
        @autorun -> Meteor.subscribe 'my_delta'


    Template.type.helpers
        schema: ->
            Docs.findOne
                type:'schema'
                slug: FlowRouter.getParam('type')

        type_docs: ->
            Docs.find
                type:FlowRouter.getParam('type')

        selected_tags: -> selected_tags.list()


        current_delta: -> 
            Docs.findOne type:'delta'


        global_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()

        single_doc: ->
            count = Docs.find({}).count()
            if count is 1 then true else false



    Template.type.events
        'click .add_type_doc': ->
            new_doc_id = Docs.insert type:FlowRouter.getParam('type')
            FlowRouter.go "/s/#{@type}/#{new_doc_id}/edit"

        'click .create_delta': (e,t)->
            Docs.insert type:'delta'


        'click .print_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            console.log delta
    
        'click .reset': ->
            delta = Docs.findOne type:'delta'
            console.log delta
            Meteor.call 'fum', delta._id, (err,res)->

        'click .edit_schema': ->
            schema = Docs.findOne
                type:'schema'
                slug: FlowRouter.getParam('type')
            FlowRouter.go "/s/#{schema.slug}/#{schema._id}/edit"

        'click .delete_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            if delta
                if confirm "delete  #{delta._id}?"
                    Docs.remove delta._id


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


    Template.type_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('_id'), FlowRouter.getParam('type')
        @autorun -> Meteor.subscribe 'bricks_from_doc_id', FlowRouter.getParam('_id')
        @autorun -> Meteor.subscribe 'schema_from_doc_id', FlowRouter.getParam('_id')
    
    Template.type_view.onCreated ->
        @autorun -> Meteor.subscribe 'schema_from_doc_id', FlowRouter.getParam('_id')
        @autorun -> Meteor.subscribe 'bricks_from_doc_id', FlowRouter.getParam('_id')
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('_id'), FlowRouter.getParam('type')

    Template.type_edit.events
        'blur .body': (e,t)->
            body = t.$('.body').val()
            Docs.update FlowRouter.getParam('id'),
                $set:body:body


        'click .toggle_complete': (e,t)->
            Docs.update FlowRouter.getParam('id'),
                $set:complete:!@complete


        'click .delete_schema': ->
            if confirm 'Confirm delete schema'
                Docs.remove @_id
                FlowRouter.go '/schemas'

