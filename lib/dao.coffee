if Meteor.isClient
    Template.dao.onCreated ->
        @autorun -> Meteor.subscribe 'session'
    
    
    Template.dao.events
        'keyup #in': (e,t)->
            if e.which is 13
                val = t.$('#in').val()
                Meteor.call 'fi', val
                    
        'click .delete_session': ->
            session = Docs.findOne type:'session'
            Docs.remove session._id
    
        'click .create_session': (e,t)->
            Docs.insert
                type:'session'
                result_ids:[]
            Meteor.call 'fi'
    
        'click .show_session': (e,t)->
            session = Docs.findOne type:'session'
            console.log session
    
        'click .reload': (e,t)->
            session = Docs.findOne type:'session'
            console.log session
            Meteor.call 'fi'
    
    
    Template.dao.helpers
        session_doc: -> Docs.findOne type:'session'
    
    
    
    Template.facet.helpers
        values: ->
            session = Docs.findOne type:'session'
            session["#{@key}_return"]?[..50]
    
        set_facet_key_class: ->
            session = Docs.findOne type:'session'
            if session.query["#{@slug}"] is @value then 'active' else ''
    
    Template.selector.events
        'click .toggle_value': ->
            # console.log @
            filter = Template.parentData()
            session = Docs.findOne type:'session'
            filter_list = session["filter_#{filter.key}"]
    
            if filter_list and @value in filter_list
                Docs.update session._id,
                    $set:
                        current_page:1
                    $pull: "filter_#{filter.key}": @value
            else
                Docs.update session._id,
                    $set:
                        current_page:1
                    $addToSet:
                        "filter_#{filter.key}": @value
            Session.set 'is_calculating', true
            # console.log 'hi call'
            Meteor.call 'fi', (err,res)->
                if err then console.log err
                else if res
                    # console.log 'return', res
                    Session.set 'is_calculating', false
    
    Template.doc_card.onCreated ->
        @autorun => Meteor.subscribe 'single_doc', @data

    Template.doc_card.events
        'click .doc_card': ->
            session = Docs.findOne type:'session'
            Docs.update facet._id,
                $set:
                    viewing_detail: true
                    detail_id: @_id
    
        
    
    Template.doc_card.helpers
        local_doc: -> Docs.findOne @valueOf()
    
        is_array: -> @field_type is 'array'
    
        doc_card_class: ->
            session = Docs.findOne type:'session'
            if session.detail_id and session.detail_id is @_id then 'raised blue' else 'secondary'
    
        view_full: ->
            # session = Docs.findOne type:'session'
            # if session.detail_id and session.detail_id is @_id then true else false
            true
    
        field_docs: ->
            session = Docs.findOne type:'session'
            local_doc =
                if @data
                    Docs.findOne @data.valueOf()
                else
                    Docs.findOne @valueOf()
            if local_doc?.type is 'field'
                Docs.find({
                    type:'field'
                    axon:$ne:true
                    schema_slugs: $in: ['field']
                }, {sort:{rank:1}}).fetch()
            else
                schema = Docs.findOne
                    type:'schema'
                    slug:session.filter_type[0]
                linked_fields = Docs.find({
                    type:'field'
                    schema_slugs: $in: [schema.slug]
                    axon:$ne:true
                    visible:true
                }, {sort:{rank:1}}).fetch()
    
    
        value: ->
            # console.log @
            session = Docs.findOne type:'session'
            schema = Docs.findOne
                type:'schema'
                slug:session.filter_type[0]
            parent = Template.parentData()
            field_doc = Docs.findOne
                type:'field'
                schema_slugs:$in:[schema.slug]
            # console.log 'field doc', field_doc
            parent["#{@key}"]
    
        doc_header_fields: ->
            session = Docs.findOne type:'session'
            local_doc =
                if @data
                    Docs.findOne @data.valueOf()
                else
                    Docs.findOne @valueOf()
            if local_doc?.type is 'field'
                Docs.find({
                    type:'field'
                    axon:$ne:true
                    header:true
                    schema_slugs: $in: ['field']
                }, {sort:{rank:1}}).fetch()
            else
                schema = Docs.findOne
                    type:'schema'
                    slug:session.filter_type[0]
                linked_fields = Docs.find({
                    type:'field'
                    schema_slugs: $in: [schema.slug]
                    header:true
                    axon:$ne:true
                }, {sort:{rank:1}}).fetch()

    
    
    
    Template.edit_field_text.helpers
        field_value: ->
            field = Template.parentData()
            field["#{@key}"]
    
    Template.edit_field_text.events
        'change .text_val': (e,t)->
            text_value = e.currentTarget.value
            # console.log @filter_id
            Docs.update @filter_id,
                { $set: "#{@key}": text_value }
    
    Template.edit_field_number.helpers
        field_value: ->
            field = Template.parentData()
            field["#{@key}"]
    
    Template.edit_field_number.events
        'change .number_val': (e,t)->
            number_value = parseInt e.currentTarget.value
            # console.log @filter_id
            Docs.update @filter_id,
                { $set: "#{@key}": number_value }
                
            
            
if Meteor.isServer
    Meteor.publish 'session', ->
        Docs.find {
                type:'session'
                author_id: Meteor.userId()
        }, {limit:1}

    Meteor.publish 'single_doc', (id)->
        Docs.find id

    Meteor.methods
        fi: (input)->
            session = Docs.findOne
                type:'session'
                author_id: Meteor.userId()
    
            Docs.update session._id,
                $set:result:input
    
            built_query = {}
    
            facets = [
                {
                    key:'tags'
                    type:'array'
                }
            ]
    
            filter_keys = ['tags']
    
            for key in filter_keys
                filter_list = session["filter_#{key}"]
                if filter_list
                    built_query["#{key}"] = $all: filter_list
    
    
            total = Docs.find(built_query).count()
    
            for facet in facets
                values = []
                key_return = []
    
                test_calc = Meteor.call 'agg', built_query, 'array', facet.key
    
                console.log test_calc
    
                Docs.update {_id:session._id},
                    { $set:"#{facet.key}_return":test_calc }
                    , ->
    
            results_cursor =
                Docs.find( built_query,
                    # {
                    #     limit:calc_page_size
                    #     sort:"#{session.sort_key}":session.sort_direction
                    #     skip:skip_amount
                    # }
                    {
                        limit:10
                    }
                )
    
            result_ids = []
            for result in results_cursor.fetch()
                result_ids.push result._id
    
    
            Docs.update {_id:session._id},
                {$set:
                    total: total
                    result_ids:result_ids
                }, ->
            return true
    
    
        agg: (query, type, key)->
            options = {
                explain:false
                }
            # console.log key
            if type is 'array'
                pipe =  [
                    { $match: query }
                    { $project: "#{key}": 1 }
                    { $unwind: "$#{key}" }
                    { $group: _id: "$#{key}", count: $sum: 1 }
                    { $sort: count: -1, _id: 1 }
                    { $limit: 20 }
                    { $project: _id: 0, name: '$_id', count: 1 }
                ]
            else
                pipe =  [
                    { $match: query }
                    { $project: "#{key}": 1 }
                    { $group: _id: "$#{key}", count: $sum: 1 }
                    { $sort: count: -1, _id: 1 }
                    { $limit: 20 }
                    { $project: _id: 0, name: '$_id', count: 1 }
                ]
    
            agg = Docs.rawCollection().aggregate(pipe,options)
    
            if agg
                agg.toArray()