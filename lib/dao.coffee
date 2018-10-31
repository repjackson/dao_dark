if Meteor.isClient
    Template.dao.onCreated ->
        @autorun -> Meteor.subscribe 'session'
    
    
    Template.dao.events
        'keyup #in': (e,t)->
            if e.which is 13
                session = Docs.findOne type:'session'
                val = t.$('#in').val()
                Docs.update session._id,
                    $set:input:val

                Meteor.call 'fi'
                    
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
    
        faceted_fields: -> [
            {
                key:'keys'
                type:'array'
            },
            {
                key:'tags'
                type:'array'
            }
        ]
        
        
    Template.facet.helpers
        selected_values: ->
            session = Docs.findOne type:'session'
            session["filter_#{@key}"]
        values: ->
            session = Docs.findOne type:'session'
            session["#{@key}_return"]?[..50]
    
    
    
    Template.facet.events
        'click .unselect': (e,t)->
            session = Docs.findOne type:'session'
            Docs.update session._id,
                $pull: "filter_#{t.data.key}": @valueOf()
    
    
    
    Template.selector.events
        'click .select': ->
            # console.log @
            filter = Template.parentData()
            session = Docs.findOne type:'session'

            Docs.update session._id,
                $set:
                    current_page:1
                $addToSet:
                    "filter_#{filter.key}": @name
            Meteor.call 'fi'
    
    Template.doc_card.onCreated ->
        @autorun => Meteor.subscribe 'single_doc', @data

    Template.doc_card.events
        'click .doc_card': ->
            session = Docs.findOne type:'session'
            Docs.update session._id,
                $set:
                    viewing_detail: true
                    detail_id: @_id
    
        
    
    Template.doc_card.helpers
        local_doc: -> Docs.findOne @valueOf()
    
        doc_card_class: ->
            session = Docs.findOne type:'session'
            if session.detail_id and session.detail_id is @_id then 'raised blue' else 'secondary'
    
        key_value: ->
            local_doc = Docs.findOne Template.parentData(1)
            value = local_doc["#{@valueOf()}"]
            # console.log 'type', typeof value
            value
            
        key_type: ->
            local_doc = Docs.findOne Template.parentData(1)
            value = local_doc["#{@valueOf()}"]
            type = typeof value
            type
            
        is_html: ->
            local_doc = Docs.findOne Template.parentData(1)
            value = local_doc["#{@valueOf()}"]
            type = typeof value
            if type is 'string'
                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test value
                html_result
                
        is_timestamp: ->
            local_doc = Docs.findOne Template.parentData(1)
            value = local_doc["#{@valueOf()}"]
            d = Date.parse(value);
            nan = isNaN d
            !nan
            
            
        is_array: ->
            local_doc = Docs.findOne Template.parentData(1)
            value = local_doc["#{@valueOf()}"]
            $.isArray value
            
            
            
if Meteor.isServer
    Meteor.publish 'session', ->
        Docs.find {
                type:'session'
                author_id: Meteor.userId()
        }, {limit:1}

    Meteor.methods
        fi: ()->
            session = Docs.findOne
                type:'session'
                author_id: Meteor.userId()
    
            built_query = {}
    
            facets = [
                {
                    key:'tags'
                    type:'array'
                }
                {
                    key:'keys'
                    type:'array'
                }
            ]
    
            filter_keys = ['tags', 'keys']
    
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