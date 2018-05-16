@selected_entities = new ReactiveArray []

Template.entitie_facet.onCreated ->
    # @autorun => 
    #     Meteor.subscribe('facet', 
    #         selected_tags.array()
    #         selected_keywords.array()
    #         selected_entities.array()
    #         selected_author_ids.array()
    #         selected_location_tags.array()
    #         selected_timestamp_tags.array()
    #         type='reddit'
    #         )


Template.entitie_facet.helpers
    entities: ->
        doc_count = Docs.find().count()
        # if selected_entities.array().length
        if 0 < doc_count < 3
            Watson_entities.find { 
                count: $lt: doc_count
                }, limit:20
        else
            Watson_entities.find({}, limit:20)
            
            
    cloud_entitie_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push 'large '
            when @index <= 10 then button_class.push ' '
            when @index <= 15 then button_class.push 'small '
            when @index <= 20 then button_class.push ' tiny'
        return button_class

    selected_entities: -> selected_entities.array()
    # selected_author_ids: -> selected_author_ids.array()
    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Watson_entities
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }



Template.entitie_facet.events
    'click .select_entitie': -> selected_entities.push @name
    'click .unselect_entitie': -> selected_entities.remove @valueOf()
    'click #clear_entities': -> selected_entities.clear()



    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_entities.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_entities.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_entities.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_entities.push doc.name
        $('#search').val ''
