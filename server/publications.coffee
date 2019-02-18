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


    
    
Meteor.publish 'bricks_from_doc_id', (tribe, id)->
    doc = Docs.findOne id
    schema = Docs.findOne
        type:'schema'
        slug:doc.type
        tribe:tribe
    Docs.find
        type:'brick'
        parent_id:schema._id
        
        
Meteor.publish 'my_delta', ->
    Docs.find
        _author_id:Meteor.userId()
        type:'delta'

        
Meteor.publish 'schema_from_slug', (tribe_slug, slug)->
    tribe = 
        Docs.findOne 
            type:'tribe'
            slug:tribe_slug
    Docs.find
        type:'schema'
        slug:slug
        tribe:tribe_slug
        
Meteor.publish 'schema_from_doc_id', (tribe_slug,id)->
    doc = Docs.findOne id
    Docs.find
        type:'schema'
        slug:doc.type
        tribe:tribe_slug
    
    
    
Meteor.publish 'tribe_schemas', (tribe)->
    Docs.find
        type:'schema'
        tribe:tribe
    
    
    
    
            
        
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
        
        
        
Meteor.publish 'schema_bricks_from_slug', (tribe_slug, type)->
    console.log tribe_slug
    console.log type
    if type in ['field', 'brick']
        schema = Docs.findOne
            type:'schema'
            slug:type
            # tribe:tribe_slug
    else
        schema = Docs.findOne
            type:'schema'
            slug:type
            tribe:tribe_slug
        
    Docs.find
        type:'brick'
        parent_id:schema._id
        
        