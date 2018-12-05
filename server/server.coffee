Meteor.methods 
    add_doc: (tags) ->
        result = Docs.insert
            tags: tags
            author_id: Meteor.userId()
            timestamp: Date.now()
            published: 1

# Accounts.config
#     forbidClientAccountCreation : true
                

Docs.allow
    insert: (userId, doc) -> true
    update: (userId, doc) -> true
    remove: (userId, doc) -> true
    # insert: (userId, doc) -> doc.author_id is userId
    # update: (userId, doc) -> doc.author_id is userId
    # remove: (userId, doc) -> doc.author_id is userId

Meteor.users.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId



