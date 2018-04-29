Template.tags.helpers
    tags: ->
        doc_count = Docs.find({}).count()
        # if selected_tags.array().length
        if 1 < doc_count < 3
            Tags.find { 
                # type:Template.currentData().type
                count: $lt: doc_count
                }, limit:20
        else
            Tags.find({}, limit:20)
            
            
    
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
