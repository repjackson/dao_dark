FlowRouter.route '/mail', 
    name:'mail'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'mail'



Meteor.methods
    # add_message: (subject_id, predicate, object_id) ->
    #     new_id = Docs.insert
    #         type: 'message'
    #         subject_id: subject_id
    #         predicate: predicate
    #         object_id: object_id
    #     return new_id


if Meteor.isClient
    Template.mail.onCreated ->
        @autorun => Meteor.subscribe 'user_mail', Meteor.userId()
        @autorun => Meteor.subscribe 'all_messages'
        # @autorun => 
        #     Meteor.subscribe('facet', 
        #         selected_theme_tags.array()
        #         selected_author_ids.array()
        #         selected_location_tags.array()
        #         selected_intention_tags.array()
        #         selected_timestamp_tags.array()
        #         type = 'message'
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

    Template.mail.helpers
        messages: -> 
            Docs.find {
                type: 'message'
                }, 
                sort: timestamp: -1
        
        
        # messages_allowed: ->
        #     # console.log message.permission
        #     if message.permission is 'denied' or 'default' 
        #         # console.log 'messages are denied'
        #         # return false
        #     if message.permission is 'granted'
        #         # console.log 'yes granted'
        #         # return true
            
            
    Template.mail.events
        # 'click #allow_messages': ->
        #     message.requestPermission()
        
        # 'click #mark_all_read': ->
        #     if confirm 'Mark all messages read?'
        #         Docs.update {},
        #             $addToSet: read_by: Meteor.userId()
                    
    Template.message.helpers
        message_segment_class: -> if Meteor.userId() in @read_by then 'basic' else ''
        
        subject_name: -> if @subject_id is Meteor.userId() then 'You' else @subject().name()
        object_name: -> if @object_id is Meteor.userId() then 'you' else @object().name()

    Template.message.events
    

if Meteor.isServer
    publishComposite 'received_messages', ->
        {
            find: ->
                Docs.find
                    type: 'message'
                    recipient_id: Meteor.userId()
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.author_id
                    }
                ]    
        }
        
    publishComposite 'all_messages', ->
        {
            find: ->
                Docs.find type: 'message'
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.subject_id
                    }
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.object_id
                    }
                ]    
        }
        
        
    publishComposite 'unread_messages', ->
        {
            find: ->
                Docs.find
                    type: 'message'
                    recipient_id: Meteor.userId()
                    read: false
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.author_id
                    }
                ]    
        }
        
        
    Meteor.publish 'message_subjects', (selected_subjects)->
        self = @
        match = {}
        
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.type = 'message'

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
        cloud.forEach (message_subject, i) ->
            self.added 'message_subjects', Random.id(),
                name: message_subject.name
                count: message_subject.count
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