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
    
    
    
    
Meteor.publish 'user_sites', (user_id)->
    user = Meteor.users.findOne user_id
    Docs.find
        _id: $in: user.site_ids
