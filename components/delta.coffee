if Meteor.isClient
    Template.facet.onRendered ->
        Meteor.setTimeout ->
            $('.accordion').accordion()
        , 1500

    Template.facet.events
        'click .ui.accordion': ->
            $('.accordion').accordion()

        'click .toggle_selection': ->
            delta = Docs.findOne type:'delta'
            facet = Template.currentData()
            Session.set 'loading', true
            if facet.filters and @name in facet.filters
                Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
                    Session.set 'loading', false
            else
                Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                    Session.set 'loading', false

        'keyup .add_filter': (e,t)->
            if e.which is 13
                delta = Docs.findOne type:'delta'
                facet = Template.currentData()
                filter = t.$('.add_filter').val()
                Session.set 'loading', true
                Meteor.call 'add_facet_filter', delta._id, facet.key, filter, ->
                    Session.set 'loading', false
                t.$('.add_filter').val('')




    Template.facet.helpers
        filtering_res: ->
            delta = Docs.findOne type:'delta'
            filtering_res = []
            if @key is '_keys'
                @res
            else
                for filter in @res
                    if filter.count < delta.total
                        filtering_res.push filter
                    else if filter.name in @filters
                        filtering_res.push filter
                filtering_res



        toggle_value_class: ->
            facet = Template.parentData()
            delta = Docs.findOne type:'delta'
            if Session.equals 'loading', true
                 'disabled inverted'
            else if facet.filters.length > 0 and @name in facet.filters
                'grey'
            else 'basic inverted'

    Template.result.onRendered ->
        # Meteor.setTimeout ->
        #     $('.progress').popup()
        # , 2000



    Template.result.onCreated ->
        @autorun => Meteor.subscribe 'doc', @data._id

    Template.result.helpers
        result: ->
            if Docs.findOne @_id
                Docs.findOne @_id
            else if Meteor.users.findOne @_id
                Meteor.users.findOne @_id


    Template.result.events
        'click .set_schema': ->
            Meteor.call 'set_delta_facets', @slug, Meteor.userId()
