Meteor.publish 'facet_users', (selected_tags, role)->
    match = { }
    # unless 'dev' in Meteor.user().roles
    #     match.published = true
    if role then match.roles = $in:[role]
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    # if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids

    Meteor.users.find match
        # limit: 10
        # sort: timestamp: -1

Meteor.publish 'user_tags', (selected_tags, role)->
    self = @
    match = {}
    # unless 'dev' in Meteor.user().roles
    #     match.published = true
    if role then match.roles = $in:[role]
    if selected_tags.length > 0 then match.tags = $all: selected_tags

    # console.log match

    cloud = Meteor.users.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 100 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    cloud.forEach (tag) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count

    self.ready()



Meteor.publish 'enrolledUser', (token) ->
    Meteor.users.find({"services.password.reset.token": token});

Meteor.publish 'me', () ->
    if Meteor.userId()
        Meteor.users.find Meteor.userId()



Meteor.publish 'user_sites', (user_id)->
    user = Meteor.users.findOne user_id
    Docs.find
        _id: $in: user.site_ids

Meteor.publish 'group_docs', (group_id)->
    Docs.find
        group_id: group_id




Meteor.publish 'bricks_from_doc_id', (tribe,schema, id)->
    doc = Docs.findOne id
    console.log 'pub bricks', tribe, schema, id
    schema = Docs.findOne
        type:'schema'
        slug:doc.type
            # tribe:tribe
    # if schema in ['schema';'tribe','block','page','brick']
    # else
    #     schema = Docs.findOne
    #         type:'schema'
    #         slug:doc.type
    #         tribe:tribe
    Docs.find
        type:'brick'
        parent_id:schema._id


Meteor.publish 'my_delta', ->
    Docs.find
        _author_id:Meteor.userId()
        type:'delta'







Meteor.publish 'schemas', (dev_mode)->
    if dev_mode
        Docs.find
            type:'schema'
    else
        if Meteor.user()
            Docs.find
                type:'schema'
                # view_roles:$in:Meteor.user().roles
        else
            Docs.find
                type:'schema'
                # view_roles:$in:['public']


Meteor.publish 'user_schemas', ()->
    Docs.find
        type:'schema'
        user_schema:true
        # view_roles:$in:Meteor.user().roles




Meteor.publish 'document_by_slug', (slug)->
    Docs.find
        type:'document'
        slug:slug


Meteor.publish 'wall_posts', (username)->
    console.log username
    Docs.find
        type:'wall_post'
        parent_username:username



Meteor.publish 'all_users', ()->
    Meteor.users.find {}





Meteor.publish 'user_messages', (username)->
    match = {}
    match.type = 'message'
    match.to_username = username
    Docs.find match

Meteor.publish 'assigned_tasks', (username, view_complete)->
    match = {}
    if view_complete then match.complete = true
    match.type = 'task'
    match.assigned_username = username

    Docs.find match
