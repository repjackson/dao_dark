Template.dao.onCreated ->
    @autorun -> Meteor.subscribe 'session'


Template.dao.events
    'keyup #in': (e,t)->
        if e.which is 13
            val = t.$('#in').val()
            console.log val
            Meteor.call 'fi', val, (e,r)->
                console.log r
                
    'click .delete_session': ->
        if confirm 'Clear Session?'
            session = Docs.findOne type:'session'
            Docs.remove session._id

    'click .create_session': (e,t)->
        new_facet_id =
            Docs.insert
                type:'session'
                result_ids:[]
                current_page:1
                page_size:10
                skip_amount:0
                view_full:true
        Meteor.call 'fi'

    'click .show_session': (e,t)->
        session = Docs.findOne type:'session'
        console.log session

    'click .reload': (e,t)->
        session = Docs.findOne type:'session'
        console.log session
        Meteor.call 'fi'


Template.selector.helpers
    selector_value: ->
        switch typeof @value
            when 'string' then @value
            when 'boolean'
                if @value is true then 'True'
                else if @value is false then 'False'
            when 'number' then @value


Template.dao.helpers
    session_doc: -> Docs.findOne type:'session'



Template.filter.helpers
    values: ->
        session = Docs.findOne type:'session'
        session["#{@key}_return"]?[..50]

    set_facet_key_class: ->
        session = Docs.findOne type:'session'
        if session.query["#{@slug}"] is @value then 'active' else ''

Template.selector.helpers
    toggle_value_class: ->
        session = Docs.findOne type:'session'
        filter = Template.parentData()
        filter_list = session["filter_#{filter.key}"]
        if filter_list and @value in filter_list then 'active' else ''

Template.filter.events
    # 'click .set_facet_key': ->
    #     session = Docs.findOne type:'session'
    'click .recalc': ->
        session = Docs.findOne type:'session'
        Meteor.call 'fo'

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