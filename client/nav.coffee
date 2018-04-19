Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'user', Meteor.userId()

Template.nav.onRendered ->
    #   // be sure to use this.$ so it is scoped to the template instead of to the window
    @$('.ui.dropdown').dropdown({on: 'hover'});


Template.nav.events
    'click #logout': -> AccountsTemplates.logout()
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

    'keyup #query': (e,t)->
        e.preventDefault
        query_tags = $('#query').val().toLowerCase()
        if e.which is 13
            if query_tags.length > 0
                split_tags = query_tags.match(/\S+/g)
                # split_tags = tags.split(',')
                $('#query').val('')
                for tag in split_tags
                    selected_tags.push tag


        
