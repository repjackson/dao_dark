FlowRouter.route '/store', 
    name:'store'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'store'



Meteor.methods
    # add_product: (subject_id, predicate, object_id) ->
    #     new_id = Docs.insert
    #         type: 'product'
    #         subject_id: subject_id
    #         predicate: predicate
    #         object_id: object_id
    #     return new_id


if Meteor.isClient
    Template.store.onCreated ->
        @autorun => Meteor.subscribe 'store', Meteor.userId()
        # @autorun => 
        #     Meteor.subscribe('facet', 
        #         selected_theme_tags.array()
        #         selected_author_ids.array()
        #         selected_location_tags.array()
        #         selected_intention_tags.array()
        #         selected_timestamp_tags.array()
        #         type = 'product'
        #         author_id = null
        #         parent_id = null
        #         tag_limit = 20
        #         doc_limit = 10
        #         view_published = null
        #         view_read = Session.get('view_read')
        #         view_bookmarked = null
        #         view_resonates = null
        #         view_complete = null
        #         view_images = null
        #         view_lightbank_type = null
    
        #         )

    Template.store.helpers
        products: -> 
            Docs.find {
                type: 'product'
                }, 
                sort: timestamp: -1
        
        
        # products_allowed: ->
        #     # console.log product.permission
        #     if product.permission is 'denied' or 'default' 
        #         # console.log 'products are denied'
        #         # return false
        #     if product.permission is 'granted'
        #         # console.log 'yes granted'
        #         # return true
            
            
    Template.store.events
        # 'click #allow_products': ->
        #     product.requestPermission()
        
        # 'click #mark_all_read': ->
        #     if confirm 'Mark all products read?'
        #         Docs.update {},
        #             $addToSet: read_by: Meteor.userId()
                    
    Template.product.helpers
        product_segment_class: -> if Meteor.userId() in @read_by then 'basic' else ''
        
        subject_name: -> if @subject_id is Meteor.userId() then 'You' else @subject().name()
        object_name: -> if @object_id is Meteor.userId() then 'you' else @object().name()

    Template.product.events
    

if Meteor.isServer
    publishComposite 'received_products', ->
        {
            find: ->
                Docs.find
                    type: 'product'
                    recipient_id: Meteor.userId()
            children: [
                { find: (product) ->
                    Meteor.users.find 
                        _id: product.author_id
                    }
                ]    
        }
        
    publishComposite 'all_products', ->
        {
            find: ->
                Docs.find type: 'product'
            children: [
                { find: (product) ->
                    Meteor.users.find 
                        _id: product.subject_id
                    }
                { find: (product) ->
                    Meteor.users.find 
                        _id: product.object_id
                    }
                ]    
        }
        
        
    publishComposite 'unread_products', ->
        {
            find: ->
                Docs.find
                    type: 'product'
                    recipient_id: Meteor.userId()
                    read: false
            children: [
                { find: (product) ->
                    Meteor.users.find 
                        _id: product.author_id
                    }
                ]    
        }
        
        
    Meteor.publish 'product_subjects', (selected_subjects)->
        self = @
        match = {}
        
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.type = 'product'

        cloud = Docs.aggregate [
            { $match: match }
            { $project: subject_id: 1 }
            { $group: _id: '$subject_id', count: $sum: 1 }
            { $match: _id: $nin: selected_subjects }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (product_subject, i) ->
            self.added 'product_subjects', Random.id(),
                name: product_subject.name
                count: product_subject.count
                index: i
    
        self.ready()
            
    
    # Meteor.publish 'usernames', (selectedTags, selectedUsernames, pinnedUsernames, viewMode)->
# Meteor.publish 'usernames', (selectedTags)->
    # self = @

    # match = {}
    # if selectedTags.length > 0 then match.tags = $all: selectedTags
    # # if selectedUsernames.length > 0 then match.username = $in: selectedUsernames

    # cloud = Docs.aggregate [
    #     { $match: match }
    #     { $project: username: 1 }
    #     { $group: _id: '$username', count: $sum: 1 }
    #     { $match: _id: $nin: selectedUsernames }
    #     { $sort: count: -1, _id: 1 }
    #     { $limit: 50 }
    #     { $project: _id: 0, text: '$_id', count: 1 }
    #     ]

    # cloud.forEach (username) ->
    #     self.added 'usernames', Random.id(),
    #         text: username.text
    #         count: username.count
    # self.ready()