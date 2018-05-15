@selected_concepts = new ReactiveArray []

Template.concept_facet.onCreated ->
    # @autorun => 
    #     Meteor.subscribe('facet', 
    #         selected_tags.array()
    #         selected_keywords.array()
    #         selected_concepts.array()
    #         selected_author_ids.array()
    #         selected_location_tags.array()
    #         selected_timestamp_tags.array()
    #         type='reddit'
    #         )


Template.concept_facet.helpers
    concepts: ->
        doc_count = Docs.find().count()
        # if selected_concepts.array().length
        if 0 < doc_count < 3
            Watson_concepts.find { 
                count: $lt: doc_count
                }, limit:42
        else
            Watson_concepts.find({}, limit:42)
            
            
    cloud_concept_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push 'large '
            when @index <= 10 then button_class.push ' '
            when @index <= 15 then button_class.push 'small '
            when @index <= 20 then button_class.push ' tiny'
        return button_class

    selected_concepts: -> selected_concepts.array()
    # selected_author_ids: -> selected_author_ids.array()
    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Watson_concepts
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }



Template.concept_facet.events
    'click .select_concept': -> selected_concepts.push @name
    'click .unselect_concept': -> selected_concepts.remove @valueOf()
    'click #clear_concepts': -> selected_concepts.clear()



    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_concepts.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_concepts.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_concepts.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_concepts.push doc.name
        $('#search').val ''
