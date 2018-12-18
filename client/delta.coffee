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

 
Template.delta.events
    'click .create_delta': (e,t)->
        Meteor.call 'create_delta', (err,res)->
            Session.set 'current_delta_id', res
        Meteor.call 'fo', Session.get('current_delta_id')
        
    'click .select_section': ->
        console.log @
        # Session.set 'current_delta_id', @_id
        # if Meteor.user()
        #     Meteor.users.update Meteor.userId(),
        #         $set: 
        #             current_delta_id: @_id
        #             current_template: 'delta'
        # Meteor.call 'fo', Session.get('current_delta_id')
        
    'click .select_delta': ->
        console.log @
        Session.set 'current_delta_id', @_id
        if Meteor.user()
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_delta_id: @_id
                    current_template: 'delta'
        Meteor.call 'fo', Session.get('current_delta_id')
    
    
    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id

    
Template.result.helpers
    result: ->
        Docs.findOne
            _id: Template.currentData()._id

    result_template: ->
        console.log @type
        if @type
            "#{@type}"
        else
            "default"