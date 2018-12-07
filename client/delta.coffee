Template.delta.onCreated ->
    @autorun -> Meteor.subscribe 'my_deltas'
Template.result.onCreated ->
    delta = Docs.findOne type:'delta'
    if delta
        @autorun -> Meteor.subscribe 'doc_id', delta.doc_id
 
 Template.delta.helpers       
    delta: -> 
        if Meteor.user()
            Docs.findOne Meteor.user().current_delta_id
    
    facets: ->
        # at least keys
        facets = []
        delta = Docs.findOne type:'delta'
        if delta 
            if delta.keys_filter
                for item in delta.keys_filter
                    facets.push item.name
        facets.push 'keys'
        facets
    


Template.result.events
    'click .edit': ->
        Docs.update Meteor.user().current_delta_id,
            $set:
                editing:true
                doc_id: @_id


Template.result.helpers
    value: ->
        filter = Template.parentData()
        filter["#{@key}"]

    is_html: -> @type is 'html'
    is_number: -> @type is 'number'
    is_array: -> @type is 'array'
    is_string: -> @type is 'string'

