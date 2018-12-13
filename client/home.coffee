
Template.home.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'my_tribe'
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'schema', 'module'
    @autorun -> Meteor.subscribe 'schema', 'tribe'
    @autorun -> Meteor.subscribe 'schema', 'field'
    @autorun -> Meteor.subscribe 'schema', 'schema'



Template.home.helpers
    my_tribe: -> 
        if Meteor.user()
            Docs.findOne
                _id: Meteor.user().current_tribe_id

    session_item_class: ->
        if Meteor.user().current_delta_id is @_id then 'active' else ''
    
    tribe_modules: ->
        if Meteor.user() 
            current_tribe = Docs.findOne Meteor.user().current_tribe_id
            Docs.find
                schema:'module'
                tribe_ids: $in: [Meteor.user().current_tribe_id]

Template.home.events
    'click .delta': ->
        Meteor.users.update Meteor.userId(),
            $set:current_template: 'delta'
   
    'click .karma': ->
        Meteor.users.update Meteor.userId(),
            $set:current_template: 'karma'
   
    'click .create_delta': (e,t)->
        new_delta_id = Docs.insert
            schema:'delta'
            view:'list'
            facets: [
                {
                    key:'keys'
                    filters: ['tags', 'timestamp']
                    res:[]
                }
            ]
        Meteor.users.update Meteor.userId(),
            $set:
                current_template: 'delta'
                current_delta_id: new_delta_id
        Meteor.call 'fo'
        
    'click .select_delta': ->
        Meteor.users.update Meteor.userId(),
            $set: 
                current_delta_id: @_id
                current_template: 'delta'


Template.home.events
    'click .select_module': ->
        user_module_delta = Docs.findOne
            schema:'delta'
            module_id: @_id
        
        if user_module_delta
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_template: 'delta'
                    current_delta_id: user_module_delta._id
        else
            new_user_module_delta_id = Docs.insert
                schema:'delta'
                view:'list'
                module_id: @_id
                # need to hook into schema fields
                
            module_child_schema = 
                Docs.findOne 
                    schema:'schema'
                    slug:@child_schema

            console.log module_child_schema


            facets = [
                {
                    key:'schema'
                    filters: [@child_schema]
                    hidden:true
                }
            ]
        
            if module_child_schema
                if module_child_schema.field_ids
                    for field_id in module_child_schema.field_ids
                        field = Docs.findOne field_id
                        console.log field.title
                        facets.push { key:field.slug }
                            
                    console.log facets
                    
                    Docs.update new_user_module_delta_id,
                        $set: facets: facets
                    
                    Meteor.users.update Meteor.userId(),
                        $set: 
                            current_template: 'delta'
                            current_delta_id: new_user_module_delta_id
                    Meteor.call 'fo'


    'click .profile': ->
        Meteor.users.update Meteor.userId(),
            $set: 
                current_template: 'profile'
        
    
    'click .logout': ->
        Meteor.logout()