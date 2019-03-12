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

    set_password: (user_id, new_password)->
        Accounts.setPassword(user_id, new_password)




    notify_message: (message_id)->
        message = Docs.findOne message_id
        if message
            console.log message
            to_user = Meteor.users.findOne message.to_user_id
            console.log to_user.emails[0].address

            message_link = "www.dao.af/u/#{to_user.username}/messages"

        	Email.send({
                to:["<#{to_user.emails[0].address}>"]
                from:"relay@dao.af"
                subject:"DAO Message Notification from #{message._author_username}"
                html: "<h3> #{message._author_username} sent you the message:</h3>"+"<h2> #{message.body}.</h2>+
                    <br><h4>View your messages here:<a href=#{message_link}>#{message_link}</a>.</h4>"
            })


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
