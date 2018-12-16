Template.delta.helpers
    card_number: ->
        delta = Docs.findOne Session.get('current_delta_id')
        if delta
            switch delta.total
                when 1 then 'one'
                # when 2 then 'two'
                # when 3 then 'three'
                else 'one'
        
    public_sessions: ->
        Docs.find
            schema:'delta'
            author_id:$exists:'false'

    delta_selector_class: ->
        if Session.equals('current_delta_id', @_id) then 'black' else ''

 
