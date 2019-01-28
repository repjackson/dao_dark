import { FlowRouter } from 'meteor/ostrio:flow-router-extra';



Template.comments_view.onCreated ->
    @autorun => Meteor.subscribe 'children', FlowRouter.getParam('id')
Template.role_editor.onCreated ->
    @autorun => Meteor.subscribe 'type', 'role'

Template.comments_view.helpers
    doc_comments: ->
        Docs.find
            type:'comment'

Template.comments_view.events
    'keyup .add_comment': (e,t)->
        if e.which is 13
            parent = Docs.findOne FlowRouter.getParam('id')
            comment = t.$('.add_comment').val()
            console.log comment
            Docs.insert
                parent_id: parent._id
                type:'comment'
                body:comment
            t.$('.add_comment').val('')

    'click .remove_comment': ->
        if confirm 'Confirm remove comment'
            Docs.remove @_id




Template.user_info.onCreated ->
    @autorun => Meteor.subscribe 'user', @data

Template.user_info.helpers
    user: -> Meteor.users.findOne @valueOf()


Template.user_list_info.onCreated ->
    @autorun => Meteor.subscribe 'user', @data

Template.user_list_info.helpers
    user: -> Meteor.users.findOne @valueOf()


Template.follow_view.helpers
    followers: ->
        Meteor.users.find
            _id: $in: @follower_ids

    following: -> @follower_ids and Meteor.userId() in @follower_ids


Template.follow_view.events
    'click .follow': ->
        Docs.update @_id,
            $addToSet:follower_ids:Meteor.userId()

    'click .unfollow': ->
        Docs.update @_id,
            $pull:follower_ids:Meteor.userId()

Template.user_list_toggle.onCreated ->
    @autorun => Meteor.subscribe 'user_list', Template.parentData(),@key

Template.user_list_toggle.events
    'click .toggle': (e,t)->
        parent = Template.parentData()
        if parent["#{@key}"] and Meteor.userId() in parent["#{@key}"]
            Docs.update parent._id,
                $pull:"#{@key}":Meteor.userId()
        else
            Docs.update parent._id,
                $addToSet:"#{@key}":Meteor.userId()


Template.user_list_toggle.helpers
    user_list_toggle_class: ->
        classes = ""
        if Meteor.user()
            parent = Template.parentData()
            # if parent["#{@key}"] and Meteor.userId() in parent["#{@key}"]
            #     classes += "#{@color} "
            if @big
                classes += ''
            else
                classes += 'icon '
        else
            classes += 'disabled '
        classes

    in_list: ->
        parent = Template.parentData()
        if parent["#{@key}"] and Meteor.userId() in parent["#{@key}"] then true else false

    list_users: ->
        parent = Template.parentData()
        Meteor.users.find _id:$in:parent["#{@key}"]













Template.voting_view.helpers
    upvote_class: -> 
        parent = Template.parentData(5)
        if parent._upvoter_ids and Meteor.userId() in parent._upvoter_ids then 'green' else 'outline'
    downvote_class: -> 
        parent = Template.parentData(5)
        if parent._downvoter_ids and Meteor.userId() in parent._downvoter_ids then 'red' else 'outline'




Template.voting_view.events
    'click .upvote': ->
        parent = Template.parentData(5)
        if parent._downvoter_ids and Meteor.userId() in parent._downvoter_ids
            Docs.update parent._id,
                $pull: _downvoter_ids:Meteor.userId()
                $addToSet: _upvoter_ids:Meteor.userId()
                $inc:points:2
        else if parent._upvoter_ids and Meteor.userId() in parent._upvoter_ids
            Docs.update parent._id,
                $pull: _upvoter_ids:Meteor.userId()
                $inc:points:-1
        else
            Docs.update parent._id,
                $addToSet: _upvoter_ids:Meteor.userId()
                $inc:points:1
        # Meteor.users.update @author_id,
        #     $inc:karma:1

    'click .downvote': ->
        parent = Template.parentData(5)
        if parent._upvoter_ids and Meteor.userId() in parent._upvoter_ids
            Docs.update parent._id,
                $pull: _upvoter_ids:Meteor.userId()
                $addToSet: _downvoter_ids:Meteor.userId()
                $inc:points:-2
        else if parent._downvoter_ids and Meteor.userId() in parent._downvoter_ids
            Docs.update parent._id,
                $pull: _downvoter_ids:Meteor.userId()
                $inc:points:1
        else
            Docs.update parent._id,
                $addToSet: _downvoter_ids:Meteor.userId()
                $inc:points:-1
        # Meteor.users.update @author_id,
        #     $inc:karma:-1





Template.add_button.events
    'click .add': ->
        Docs.insert
            type: @type



Template.add_type_button.events
    'click .add': ->
        new_id = Docs.insert type: @type
        Router.go "/edit/#{new_id}"

Template.view_user_button.events
    'click .view_user': ->
        Router.go "/u/#{username}"

Template.clone_button.events
    'click .clone_doc': ->
        doc = @
        keys = @_keys
        cloned_fields = {}
        for key in keys
            cloned_fields["#{key}"] = ''
            cloned_fields["_#{key}"] = doc["_#{key}"]
        cloned_fields['_keys'] = keys
        # console.log cloned_fields
        cloned_id = Docs.insert cloned_fields
        FlowRouter.go "/edit/#{cloned_id}"
            
            
            
Template.toggle_friend.helpers
    is_friend: ->
        Meteor.user().friend_ids and @_id in Meteor.user().friend_ids
        
        
Template.toggle_friend.events
    'click .add_friend': ->
        Meteor.users.update Meteor.userId(),
            $addToSet: friend_ids:@_id
        
    'click .remove_friend': ->
        Meteor.users.update Meteor.userId(),
            $pull: friend_ids:@_id
        
        
        