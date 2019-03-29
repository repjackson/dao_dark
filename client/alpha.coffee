
if Meteor.isClient
    Template.alpha.onCreated ->
        @autorun -> Meteor.subscribe 'my_delta'


    Template.alpha.helpers
        selected_tags: -> selected_tags.list()

        current_delta: ->
            Docs.findOne
                type:'delta'
                # _author_id:Meteor.userId()


        global_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()

        single_doc: ->
            delta = Docs.findOne type:'delta'
            count = delta.result_ids.length
            if count is 1 then true else false




    Template.alpha.events
        'click .create_delta': (e,t)->
            Docs.insert
                type:'delta'

        'click .print_delta': (e,t)->
            delta = Docs.findOne type:'delta'
            console.log delta

        'click .reset': ->
            delta = Docs.findOne type:'delta'
            Meteor.call 'fum', delta._id, (err,res)->

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
