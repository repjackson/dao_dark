Meteor.methods
    create_user: (options)->
        new_id = Accounts.createUser options
        return new_id

    update_username:  (username) ->
        userId = Meteor.userId()
        if not userId
            throw new Meteor.Error(401, "Unauthorized")
        Accounts.setUsername(userId, username)
        return "Updated Username: #{username}"
        
    lookup_user: (username_query)->
        found_users =
            Meteor.users.find({
                username: {$regex:"#{username_query}", $options: 'i'}
                }).fetch()
        found_users
        