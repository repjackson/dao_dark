Template.dao.onCreated ->
    @autorun -> Meteor.subscribe 'facet'
    @autorun => Meteor.subscribe 'type', 'filter'
    @autorun => Meteor.subscribe 'type', 'schema'
    @autorun => Meteor.subscribe 'type', 'field'

    # @autorun => Meteor.subscribe 'type', 'ticket_type'
    Session.setDefault 'is_calculating', false

Template.detail_pane.onCreated ->
    facet = Docs.findOne type:'facet'
    if facet
        @autorun => Meteor.subscribe 'single_doc', facet.detail_id

Template.facet_segment.onCreated ->
    @autorun => Meteor.subscribe 'single_doc', @data

Template.facet_segment.events
    'click .facet_segment': ->
        facet = Docs.findOne type:'facet'
        Docs.update facet._id,
            $set:
                viewing_detail: true
                detail_id: @_id


Template.facet_segment.helpers
    local_doc: ->
        if @data
            Docs.findOne @data.valueOf()
        else
            Docs.findOne @valueOf()

    is_array: -> @field_type is 'array'
    
    keys: ->
        if @data
            local = Docs.findOne @data.valueOf()
        else
            local = Docs.findOne @valueOf()
        _.keys local


    facet_segment_class: ->
        facet = Docs.findOne type:'facet'
        if facet.detail_id and facet.detail_id is @_id then 'tertiary' else ''


    field_docs: -> [ { slug:'type',type:'string' } ]


    value: ->
        facet = Docs.findOne type:'facet'
        parent = Template.parentData()
        parent["#{@}"]




Template.toggle_facet_config.helpers
    boolean_true: ->
        facet = Docs.findOne type:'facet'
        if facet then facet["#{@key}"]

Template.toggle_facet_config.events
    'click .enable_key': ->
        facet = Docs.findOne type:'facet'
        Docs.update facet._id,
            $set:"#{@key}":true

    'click .disable_key': ->
        facet = Docs.findOne type:'facet'
        Docs.update facet._id,
            $set:"#{@key}":false


Template.dao.events
    'click .close_details': ->
        facet = Docs.findOne type:'facet'
        Docs.update facet._id,
            $set: viewing_detail: false

    'click .delete_facet': ->
        if confirm 'Clear Session?'
            facet = Docs.findOne type:'facet'
            Docs.remove facet._id

    'click .create_facet': (e,t)->
        new_facet_id =
            Docs.insert
                type:'facet'
                result_ids:[]
                current_page:1
                page_size:10
                skip_amount:0
                view_full:true
        Meteor.call 'fo', new_facet_id

    'click .add_doc': (e,t)->
        facet = Docs.findOne type:'facet'
        type = facet.filter_type[0]
        user = Meteor.user()
        new_doc = {}
        if type
            new_doc['type'] = type
        new_id = Docs.insert(new_doc)

        Docs.update facet._id,
            $set:
                viewing_detail:true
                detail_id:new_id
                editing_mode:true

    'click .add_field': (e,t)->
        facet = Docs.findOne type:'facet'
        type = facet.filter_type[0]
        Docs.insert
            type:'field'
            schema_slugs:[type]
        Meteor.call 'fo'

    'click .show_facet': (e,t)->
        facet = Docs.findOne type:'facet'
        console.log facet

    'click .reload': (e,t)->
        facet = Docs.findOne type:'facet'
        console.log facet
        Meteor.call 'fo'


Template.selector.helpers
    selector_value: ->
        switch typeof @value
            when 'string' then @value
            when 'boolean'
                if @value is true then 'True'
                else if @value is false then 'False'
            when 'number' then @value


# Template.detail_pane.onCreated ->
#     Meteor.setTimeout ->
#         $('.accordion').accordion();
#     , 500


Template.detail_pane.events
    'click .remove_doc': ->
        facet = Docs.findOne type:'facet'
        target_doc = Docs.findOne _id:facet.detail_id
        if confirm "Delete #{target_doc.title}?"
            Docs.remove target_doc._id
            Docs.update facet._id,
                $set:
                    detail_id:null
                    editing_mode:false
                    viewing_detail:false

    'click .enable_editing': ->
        facet=Docs.findOne type:'facet'
        Docs.update facet._id,
            $set:editing_mode:true
    'click .disable_editing': ->
        facet=Docs.findOne type:'facet'
        Docs.update facet._id,
            $set:editing_mode:false



Template.detail_pane.helpers
    detail_doc: ->
        facet = Docs.findOne type:'facet'
        detail = Docs.findOne facet.detail_id

        console.log detail

    keys: ->
        facet = Docs.findOne type:'facet'
        detail = Docs.findOne facet.detail_id
        _.keys detail

    value: -> 
        # console.log Template.parentData()
        facet = Docs.findOne type:'facet'
        detail = Docs.findOne facet.detail_id
        detail["#{@valueOf()}"]



    facet_doc: -> Docs.findOne type:'facet'


    can_edit: ->
        facet = Docs.findOne type:'facet'
        type_key = facet.filter_type[0]
        schema = Docs.findOne
            type:'schema'
            slug:type_key

        my_role = Meteor.user()?.roles?[0]
        if my_role
            if schema.editable_roles
                if my_role in schema.editable_roles
                    true
                else
                    false
            else
                false
        else
            false



Template.dao.helpers
    is_calculating: -> Session.get('is_calculating')
    facet_doc: -> Docs.findOne type:'facet'


    visible_result_ids: ->
        facet = Docs.findOne type:'facet'
        if facet.result_ids then facet.result_ids[..10]

    current_type: ->
        facet = Docs.findOne type:'facet'
        type_key = facet.filter_type[0]
        Docs.findOne
            type:'schema'
            slug:type_key

    can_add: ->
        facet = Docs.findOne type:'facet'
        type_key = facet.filter_type[0]
        schema = Docs.findOne
            type:'schema'
            slug:type_key

        my_role = Meteor.user()?.roles?[0]
        if my_role
            if schema.addable_roles
                if my_role in schema.addable_roles
                    true
                else
                    false
            else
                false
        else
            false


    faceted_fields: ->
        facet = Docs.findOne type:'facet'
        current_type = facet.filter_type[0]
        faceted_fields = []
        if current_type
            fields =
                Docs.find({
                    type:'field'
                    schema_slugs:$in:[current_type]
                    faceted: true
                }, {sort:{rank:1}}).fetch()
        else
            fields = [{title:'Tags', key:'tags'}]




Template.filter.helpers
    values: ->
        facet = Docs.findOne type:'facet'
        facet["#{@key}_return"]?[..50]

    set_facet_key_class: ->
        facet = Docs.findOne type:'facet'
        if facet.query["#{@slug}"] is @value then 'active' else ''

Template.selector.helpers
    toggle_value_class: ->
        facet = Docs.findOne type:'facet'
        filter = Template.parentData()
        filter_list = facet["filter_#{filter.key}"]
        if filter_list and @value in filter_list then 'active' else ''

Template.filter.events
    # 'click .set_facet_key': ->
    #     facet = Docs.findOne type:'facet'
    'click .recalc': ->
        facet = Docs.findOne type:'facet'
        Meteor.call 'fo'

Template.selector.events
    'click .toggle_value': ->
        # console.log @
        filter = Template.parentData()
        facet = Docs.findOne type:'facet'
        filter_list = facet["filter_#{filter.key}"]

        if filter_list and @value in filter_list
            Docs.update facet._id,
                $set:
                    current_page:1
                $pull: "filter_#{filter.key}": @value
        else
            Docs.update facet._id,
                $set:
                    current_page:1
                $addToSet:
                    "filter_#{filter.key}": @value
        Session.set 'is_calculating', true
        # console.log 'hi call'
        Meteor.call 'fo', (err,res)->
            if err then console.log err
            else if res
                # console.log 'return', res
                Session.set 'is_calculating', false

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