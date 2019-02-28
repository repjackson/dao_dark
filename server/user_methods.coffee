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
            
    lookup_username: (username_query)->
        found_users =
            Docs.find({
                type:'person'
                username: {$regex:"#{username_query}", $options: 'i'}
                }).fetch()
        found_users
            
    lookup_first_name: (first_name)->
        found_people =
            Docs.find({
                type:'person'
                first_name: {$regex:"#{first_name}", $options: 'i'}
                }).fetch()
        found_people
            
    lookup_last_name: (last_name)->
        found_people =
            Docs.find({
                type:'person'
                last_name: {$regex:"#{last_name}", $options: 'i'}
                }).fetch()
        found_people
        