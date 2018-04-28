Template.reference_other_children.onCreated ->
    # @autorun => Meteor.subscribe 'child_docs', @data.doc_id
    # @autorun => Meteor.subscribe 'doc', @data.doc_id
    @autorun => Meteor.subscribe 'type', @data.type
    
            
Template.reference_other_children.helpers
    # selector: -> Docs.findOne @doc_id

    available_children: ->
        # Docs.find parent_id:@doc_id
        Docs.find(type:'field')
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        # if doc["#{@key}"]
        #     Docs.find
        #         # parent_id:@doc_id
        #         type:@type
        #         _id:$nin:doc["#{@key}"]
        # else
        #     Docs.find
        #         # parent_id:@doc_id
        #         type:@type
        
        
    selected_children: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc["#{@key}"]
            Docs.find
                # parent_id:@doc_id
                _id:$in:doc["#{@key}"]
        
    child_field_toggle_class: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc and doc.field_ids and @_id in doc.field_ids then 'active' else ''

Template.reference_other_children.events
    'click .select_child': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @
        passed_key = Template.parentData(0).key
        
        if doc["#{passed_key}"] 
            if @_id in doc["#{passed_key}"]
                Docs.update doc._id,
                    $pull: "#{passed_key}": @_id
            else
                Docs.update doc._id,
                    $addToSet: "#{passed_key}": @_id
        else
            Docs.update doc._id,
                $set: "#{passed_key}": []
     
    'click .disable_child': ->
        passed_key = Template.parentData(0).key
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.update doc._id,
            $pull: "#{passed_key}": @_id
        



Template.ownership.events
    'click #make_author_owner': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Meteor.call 'calculate_owner_ids', doc._id
        # Meteor.call 'change_ownership', doc._id, doc._author_id, 100     







# Template.resonates_list.helpers
#     resonates_with_people: ->
#         if @favoriters
#             if @favoriters.length > 0
#         # console.log @favoriters
#                 Meteor.users.find _id: $in: @favoriters
    
    
            
# Template.bookmarked_by_list.onCreated ->
#     @autorun => Meteor.subscribe 'bookmarked_by', Template.parentData()._id
    
# Template.bookmarked_by_list.helpers
#     bookmarked_by: ->
#         if @bookmarked_ids
#             if @bookmarked_ids.length > 0
#         # console.log @bookmarked_ids
#                 Meteor.users.find _id: $in: @bookmarked_ids
#         else 
#             false
            
            

    
    
Template.doc_matches.onCreated ->
    @is_calculating = new ReactiveVar 'false'
    
Template.doc_matches.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.doc_match.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.doc_matches.helpers
    # calculate_button_class: ->
        # if Template.instance().is_calculating then 'loading' else ''
    
Template.doc_matches.events
    'click #compute_doc_matches': ->
        $( "#compute_doc_matches" ).toggleClass( "loading" )
        # console.log @
        Meteor.call 'find_top_doc_matches', @_id, (err, res)->
            $( "#compute_doc_matches" ).toggleClass( "loading" )
            $( ".title" ).addClass( "active" )
            $( ".match_content" ).addClass( "active" )
            # console.log res
            
            
Template.doc_match.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data.doc_id
            
Template.doc_match.helpers
    match_doc: -> Docs.findOne @doc_id
            
            
            
        
        
# Template.parent_doc_accordion.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 500
    
# # Template.parent_doc_accordion.onCreated ->
#     # console.log @data
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
    
    
Template.parent_doc_segment.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.parent_doc_segment.onCreated ->
    # console.log @data
    @autorun => Meteor.subscribe 'parent_doc', @data._id
    
    
# Template.parent_link.onCreated ->
#     # console.log @data
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
    
# Template.parent_link.helpers
#     parent: -> Docs.findOne _id: @parent_id
    
    
    
# Template.view_published_toggle.helpers
#     viewing_mine: -> Session.equals 'view_private',true  
#     viewing_all: -> Session.equals 'view_private',false  


# Template.view_published_toggle.events
#     'click #view_my_entries': (e,t)-> Session.set('view_private',true)    
#     'click #view_all_entries': (e,t)-> Session.set('view_private', false)    


# Template.view_read_toggle.helpers
#     viewing_unread: -> Session.equals 'view_unread', true  
#     viewing_all: -> Session.equals 'view_unread',false  


# Template.view_read_toggle.events
#     'click #view_unread': (e,t)-> Session.set('view_unread', true)    
#     'click #view_all': (e,t)-> Session.set('view_unread', false)    



# Template.instance().stripe = Stripe.configure(
#     key: stripe_key
#     image: '/toriwebster-logomark-04.png'
#     locale: 'auto'
#     # zipCode: true
#     token: (token) ->
#         # console.log token
#         purchasing_item = Docs.findOne Session.get 'purchasing_item'
#         console.dir 'purchasing_item', purchasing_item
#         charge = 
#             amount: purchasing_item.price*100
#             currency: 'usd'
#             source: token.id
#             description: token.description
#             receipt_email: token.email
#         Meteor.call 'processPayment', charge, (error, response) =>
#             if error then Bert.alert error.reason, 'danger'
#             else
#                 Meteor.call 'register_transaction', purchasing_item._id, (err, response)->
#                     if err then console.error err
#                     else
#                         Bert.alert "You have purchased #{purchasing_item.title}.", 'success'
#                         Docs.remove Session.get('current_cart_item')
#                         FlowRouter.go "/account"
#     # closed: ->
#     #     Bert.alert "Payment Canceled", 'info', 'growl-top-right'
# )


# Template.icon.helpers
    # 
# Template.response_count.onCreated ->
#     @autorun => Meteor.subscribe 'response_count', @data._id

# Template.save_button.events
#     'click #toggle_off_editing': -> Session.set 'editing', false
    
    
Template.add_doc_button.events
    'click #add_doc': ->
        new_id = Docs.insert type:@type
        FlowRouter.go "/edit/#{new_id}"

    
    
                
            
# Template.edit_child_fields.onCreated ->
#     Meteor.subscribe 'fields'
            
# Template.edit_child_fields.helpers
#     available_child_fields: ->
#         Docs.find
#             type: 'component'
#     # child_field_toggle_class: ->
#     #     doc = Docs.findOne FlowRouter.getParam('doc_id')
#     #     if @slug in doc.child_fields then 'active' else ''

# Template.edit_child_fields.events
#     'click .toggle_child_field': ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         if doc.child_field_ids 
#             if @_id in doc.child_field_ids
#                 Docs.update doc._id,
#                     $pull: "child_field_ids": @_id
#             else
#                 Docs.update doc._id,
#                     $addToSet: "child_field_ids": @_id
#         else
#             Docs.update doc._id,
#                 $set: "child_field_ids": []
     


     
# Template.edit_child_actions.onCreated ->
#     Meteor.subscribe 'actions'
            
# Template.edit_child_actions.helpers
#     child_actions: ->
#         Docs.find
#             type: 'action'
    
    
#     child_action_toggle_class: ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         if @slug in doc.child_actions then 'active' else ''



# Template.edit_child_actions.events
#     'click .toggle_child_action': ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         if doc.child_actions 
#             if @slug in doc.child_actions
#                 Docs.update doc._id,
#                     $pull: "child_actions": @slug
#             else
#                 Docs.update doc._id,
#                     $addToSet: "child_actions": @slug
#         else
#             Docs.update doc._id,
#                 $set: "child_actions": []
     



     
                
# Template.select_template.onCreated ->
#     Meteor.subscribe 'templates'
            
# Template.select_template.helpers
#     templates: ->
#         Docs.find
#             type: 'template'
    
#     child_field_toggle_class: ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         if @slug is doc.template then 'active' else ''

# Template.select_template.events
#     'click .select_template': ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         if doc.template 
#             Docs.update doc._id,
#                 $set: template: @slug
#         else
#             Docs.update doc._id,
#                 $set: template: ''
 
 
                
# Template.child_authors.onCreated ->
#     # console.log @data
#     # @autorun => Meteor.subscribe 'usernames'
#     @autorun => Meteor.subscribe 'child_docs', @data._id


# Template.response_list.onCreated ->
#     @autorun => Meteor.subscribe 'child_docs', @data._id

# Template.response_list.helpers
#     responses: ->
#         Docs.find
#             parent_id: @_id



# Template.user_image_name.onCreated ->
#     @autorun => Meteor.subscribe 'person_by_id', @data.user_id

# Template.user_image_name.helpers
#     user: -> Meteor.users.findOne Template.currentData().user_id
    
# Template.user_image.onCreated ->
#     @autorun => Meteor.subscribe 'person_by_id', @data.user_id

# Template.user_image.helpers
#     user: -> Meteor.users.findOne Template.currentData().user_id
    

# Template.check_completion_button.events
#     'click #check_completion': ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         # console.log 'completion_type', doc.completion_type
#         Meteor.call 'calculate_doc_completion', FlowRouter.getParam('doc_id')




Template.toggle_friend.helpers
    is_friend: -> if Meteor.user()?.friends then @_id in Meteor.user().friends
        
Template.toggle_friend.events
    'click #add_friend': (e,t)-> 
        Meteor.users.update Meteor.userId(), $addToSet: friends: @_id

        # Meteor.call 'add_notification', @_id, 'friended', Meteor.userId()

    'click #remove_friend': (e,t)-> 
        Meteor.users.update Meteor.userId(), $pull: friends: @_id

        # Meteor.call 'add_notification', @_id, 'unfriended', Meteor.userId()



Template.dev_footer.onCreated ->
    @autorun -> Meteor.subscribe('parent_doc', FlowRouter.getParam('doc_id'))
    Session.setDefault 'show_child_docs', false
Template.dev_footer.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    show_child_docs: -> Session.get 'show_child_docs'

Template.dev_footer.events
    'click #create_child': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.insert
            parent_id: doc._id
    # 'click #trickle_down': ->
    #     doc = Docs.findOne FlowRouter.getParam('doc_id')
    #     Meteor.call 'calculate_child_ancestor_array', FlowRouter.getParam('doc_id')
        
        
    'click #create_parent': ->
        parent_doc_id = Docs.insert {}
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: parent_doc_id
        FlowRouter.go "/view/#{parent_doc_id}"

    'click #move_above_parent': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        parent_doc = Docs.findOne doc.parent_id
        console.log 'grandparent id', parent_doc.parent_id
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: parent_doc.parent_id
    
    
    'click #toggle_child_docs': ->
        Session.set 'show_child_docs', !Session.get('show_child_docs')


Template.published.helpers
    published_class: -> if @published is 1 then 'active' else ''
    published_anonymously_class: -> if @published is 0 then 'active' else ''
    private_class: -> if @published is -1 then 'active' else ''
    is_published: -> @published is 1
    published_anonymously: -> @published is 0
    is_private: -> @published is -1
Template.published.events
    'click #publish': (e,t)-> 
        Docs.update @_id, $set: published: 1
    'click #unpublish': (e,t)-> 
        Docs.update @_id, $set: published: -1
    'click #publish_anonymously': ->
        Docs.update @_id, $set: published: 0
        


Template.add_child_button.events
    'click #add_child': ->
        child_id = Docs.insert
            parent_id: @_id
            
        FlowRouter.go "/edit/#{child_id}"
        
        
        
Template.vote_button.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'

Template.vote_button.events
    'click .vote_up': (e,t)-> 
        if Meteor.userId()
            Meteor.call 'vote_up', @_id
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() then Meteor.call 'vote_down', @_id
        else FlowRouter.go '/sign-in'
            
        
        
Template.toggle_key.helpers
    toggle_key_button_class: -> 
        current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log current_doc["#{@key}"]
        # console.log @key
        # console.log Template.parentData()
        # console.log Template.parentData()["#{@key}"]
        if @value
            if current_doc["#{@key}"] is @value then 'grey' else ''
        else if current_doc["#{@key}"] is true then 'grey' else ''


Template.toggle_key.events
    'click #toggle_key': ->
        # console.log @
        if @value
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": "#{@value}"
        else if Template.parentData()["#{@key}"] is true
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": false
        else
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": true


Template.read_by_list.onCreated ->
    @autorun => Meteor.subscribe 'read_by', Template.parentData()._id
    
Template.read_by_list.helpers
    read_by: ->
        if @read_by
            if @read_by.length > 0
        # console.log @read_by
                Meteor.users.find _id: $in: @read_by
        else 
            false
            
            
            
Template.mark_read.events
    'click .mark_read': (e,t)-> 
        Meteor.call 'mark_read', @_id
        
    'click .mark_unread': (e,t)-> Meteor.call 'mark_unread', @_id

Template.mark_read.helpers
    read: -> @read_by and Meteor.userId() in @read_by
    # read: -> true
    


    
Template.named_content.onCreated ->
    @autorun => Meteor.subscribe 'named_doc', @data.name
    
Template.named_content.events
    'click #create_doc': ->
        Docs.insert
            name: @name
            
Template.named_content.helpers
    named_doc: ->
        Docs.findOne 
            name: Template.currentData().name
            
            
Template.add_button.events
    'click #add': -> 
        id = Docs.insert type:@type
        FlowRouter.go "/edit/#{id}"
            
            
Template.add_button.events
    'click #add': -> 
        id = Docs.insert type:@type
        FlowRouter.go "/edit/#{id}"


Template.reference_office.onCreated ->
    @autorun =>  Meteor.subscribe 'docs', [], @data.type
Template.reference_customer.onCreated ->
    @autorun =>  Meteor.subscribe 'docs', [], @data.type

Template.associated_users.onCreated ->
    @autorun =>  Meteor.subscribe 'docs', [], 'person'
Template.associated_users.helpers
    users: -> Docs.find type:'person'


Template.reference_office.helpers
    settings: -> 
        # console.log @
        {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Docs
                    field: "#{@search_field}"
                    matchAll: true
                    filter: { type: "#{@type}" }
                    template: Template.office_result
                }
            ]
        }

Template.reference_customer.helpers
    settings: -> 
        # console.log @
        {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Docs
                    field: "#{@search_field}"
                    matchAll: true
                    filter: { type: "#{@type}" }
                    template: Template.customer_result
                }
            ]
        }


Template.reference_office.events
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        searched_value = doc["#{template.data.key}"]
        # console.log 'template ', template
        # console.log 'search value ', searched_value
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "#{template.data.key}": "#{doc._id}"
        $('#search').val ''

Template.reference_customer.events
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        searched_value = doc["#{template.data.key}"]
        # console.log 'template ', template
        # console.log 'search value ', searched_value
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "#{template.data.key}": "#{doc._id}"
        $('#search').val ''




Template.set_view_mode.helpers
    view_mode_button_class: -> if Session.equals('view_mode', @view) then 'active' else 'basic'

Template.set_view_mode.events
    'click #set_view_mode': -> Session.set 'view_mode', @view
            
Template.set_session_button.events
    'click .set_session_filter': -> Session.set "#{@key}", @value
            
Template.set_session_button.helpers
    filter_class: -> 
        if Session.equals("#{@key}","all") 
            if @value is 'all'
                'active' 
            else
                'basic'
        else if Session.get("#{@key}")
            if Session.equals("#{@key}", parseInt(@value))
                'active'
            else
                'basic'
            
            
            
Template.set_session_item.events
    'click .set_session_filter': -> Session.set "#{@key}", @value
            

Template.delete_button.events
    'click #delete': ->
        template = Template.currentData()
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, =>
            # doc = Docs.findOne FlowRouter.getParam('doc_id')
            # Docs.remove doc._id, ->
            #     FlowRouter.go "/docs"
            console.log template



Template.edit_link.events
    'blur #link': ->
        link = $('#link').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: link: link
            
            
Template.publish_button.events
    'click #publish': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: published: true

    'click #unpublish': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: published: false
            
            
Template.call_method.events
    'click .call_method': -> 
        # console.log Template.parentData(1)
        Meteor.call @name, Template.parentData(1)._id, (err,res)->
            # if err then console.log err
            # else
                # console.log 'res', res
                
                
Template.html_create.onCreated ->
    @autorun => Meteor.subscribe 'facet_doc', @data.tags
    
Template.html_create.helpers
    doc: ->
        tags = Template.currentData().tags
        split_array = tags.split ','

        Docs.findOne
            tags: split_array

    template_tags: -> Template.currentData().tags

    doc_classes: -> Template.parentData().classes

Template.html_create.events
    'click .create_doc': (e,t)->
        tags = t.data.tags
        split_array = tags.split ','
        new_id = Docs.insert
            tags: split_array
        Session.set 'editing_id', new_id

    'blur #staff': ->
        staff = $('#staff').val()
        Docs.update @_id,
            $set: staff: staff                
            
            
Template.google_places_input.onRendered ->
    # input = document.getElementById('google_places_field');
    # options = {
    #     types: ['geocode'],
    #     # componentRestrictions: {country: 'fr'}
    # }
    # @autocomplete = new google.maps.places.Autocomplete(input, options);
    # # console.log @autocomplete.getPlace
    @autorun(() =>
        if GoogleMaps.loaded()
            # $('#google_places_field').geocomplete();
            $("#google_places_field").geocomplete().bind("geocode:result", (event, result)->
                console.log(result)
                lat = result.geometry.location.lat()
                long = result.geometry.location.lng()
                result.lat = lat
                result.lng = long
                if confirm "change location to #{result.formatted_address}?"
                    Meteor.call 'update_location', FlowRouter.getParam('doc_id'), result
                )
    )


# Template.google_places_input.events
    # 'change #google_places_field': (e,t)->
    #     console.log $('#google_places_field').geocomplete();

        # result = t.autocomplete.gm_accessors_.place.jd.w3
        # console.dir result
        # Meteor.call 'update_location', FlowRouter.getParam('doc_id'), result, (err,res)->
            # console./log res
        # stuff = Template.instance().autocomplete.gm_accessors_.place
        # Docs.update FlowRouter.getParam('doc_id'),
        #     $set: stuff: stuff
        # console.dir stuff.jd.formattedPrediction
        
Template.office_map.onRendered ->
    doc = Docs.findOne FlowRouter.getParam('doc_id')
    # console.log doc.location_ob.geometry
    mymap = L.map('map').setView([doc.location_lat, doc.location_lng], 15);
    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
        # attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
        maxZoom: 18,
        id: 'mapbox.streets',
        accessToken: 'pk.eyJ1IjoicmVwamFja3NvbiIsImEiOiJjamc4dGtiYm4yN245MnFuNWMydWNuaXJlIn0.z3_-xuCT46yTC_6Zhl34kQ'
    }).addTo(mymap);

Template.toggle_boolean.events
    'click .toggle_boolean_button': ->
        # console.log @key
        # console.log Template.parentData().["#{@key}"]
        # console.log Template.parentData()
        parent = Template.parentData()
        # console.log @
        doc = Docs.findOne parent._id
        if parent["#{@key}"] is true
            Docs.update parent._id,
                $set: "#{@key}": false
        else
            Docs.update parent._id,
                $set: "#{@key}": true
            
            
            
            