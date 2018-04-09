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
        if @_id in doc.field_ids then 'active' else ''

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
            
            

    
    
# Template.doc_matches.onCreated ->
#     @is_calculating = new ReactiveVar 'false'
    
# Template.doc_matches.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 500
    
# Template.doc_match.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 500
    
# Template.doc_matches.helpers
#     # calculate_button_class: ->
#         # if Template.instance().is_calculating then 'loading' else ''
    
# Template.doc_matches.events
#     'click #compute_doc_matches': ->
#         $( "#compute_doc_matches" ).toggleClass( "loading" )
#         # console.log @
#         Meteor.call 'find_top_doc_matches', @_id, (err, res)->
#             $( "#compute_doc_matches" ).toggleClass( "loading" )
#             $( ".title" ).addClass( "active" )
#             $( ".match_content" ).addClass( "active" )
#             # console.log res
            
            
# Template.doc_match.onCreated ->
#     @autorun => Meteor.subscribe 'doc', @data.doc_id
            
# Template.doc_match.helpers
#     match_doc: -> Docs.findOne @doc_id
            
            
            
        
        
# Template.parent_doc_accordion.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 500
    
# # Template.parent_doc_accordion.onCreated ->
#     # console.log @data
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
    
    
# Template.parent_doc_segment.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 500
    
# Template.parent_doc_segment.onCreated ->
#     # console.log @data
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
    
    
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
