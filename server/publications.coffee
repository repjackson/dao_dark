Meteor.publish 'type', (type)->
    # console.log type
    Docs.find {type: type},
        limit: 20
    
Meteor.publish 'child_docs', (parent_id)->
    Docs.find {parent_id: parent_id},
        limit: 20
    
Meteor.publish 'my_children', (parent_id)->
    Docs.find {
        author_id: Meteor.userId()
        parent_id: parent_id
    }, limit: 10
        
Meteor.publish 'parent_doc', (child_id)->
    child_doc = Docs.findOne child_id
    if child_doc
        Docs.find
            _id: child_doc.parent_id
    

Meteor.publish 'top_posts', ->
    Docs.find {},
        {
            sort: points:-1
            limit: 10
        }

Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id
    
    
Meteor.publish 'user', (user_id)->
    Meteor.users.find user_id
    
    
Meteor.publish 'top_users', ->
    Meteor.users.find()
    
    
    
    
Meteor.publish 'person_by_id', (id)->
    # console.log id
    Meteor.users.find id,
        fields:
            tags: 1
            profile: 1
            points: 1            
            
Meteor.publish 'all_people', ()->
    Meteor.users.find {}
            

Meteor.publish 'people', (selected_people_tags)->
    match = {}
    if selected_people_tags.length > 0 then match.tags = $all: selected_people_tags
    match._id = $ne: @userId
    # match["profile.published"] = true
    Meteor.users.find match,
        limit: 20


Meteor.publish 'people_tags', (selected_people_tags)->
    self = @
    match = {}
    if selected_people_tags.length > 0 then match.tags = $all: selected_people_tags
    match._id = $ne: @userId
    # match["profile.published"] = true

    # console.log match

    people_cloud = Meteor.users.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_people_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 42 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log 'cloud, ', people_cloud
    people_cloud.forEach (tag, i) ->
        self.added 'people_tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()
        


Meteor.publish 'user_docs', (username, selected_theme_tags)->
    # console.log selected_theme_tags
    user = Meteor.users.findOne username: username
    Docs.find {
        # type: 'journal'
        author_id: Meteor.userId()
        published: 1
        # tags: $in: selected_theme_tags
        }, sort: timestamp: -1    
        
        
        
Meteor.publish 'facet', (
    selected_tags
    editing_id
    )->
    
        if editing_id
            Docs.find editing_id
        else
        
            self = @
            match = {}
            
            # match.tags = $all: selected_tags
    
            if selected_tags.length > 0 then match.tags = $all: selected_tags
            
            
            
            tag_cloud = Docs.aggregate [
                { $match: match }
                { $project: tags: 1 }
                { $unwind: "$tags" }
                { $group: _id: '$tags', count: $sum: 1 }
                { $match: _id: $nin: selected_tags }
                { $sort: count: -1, _id: 1 }
                { $limit:100 }
                { $project: _id: 0, name: '$_id', count: 1 }
                ]
            # console.log 'theme tag_cloud, ', tag_cloud
            tag_cloud.forEach (tag, i) ->
                self.added 'tags', Random.id(),
                    name: tag.name
                    count: tag.count
                    index: i
    
            # doc_results = []
            subHandle = Docs.find(match, {limit:5, sort: {timestamp:-1, tag_count:1}}).observeChanges(
                added: (id, fields) ->
                    # console.log 'added doc', id, fields
                    # doc_results.push id
                    self.added 'docs', id, fields
                changed: (id, fields) ->
                    # console.log 'changed doc', id, fields
                    self.changed 'docs', id, fields
                removed: (id) ->
                    # console.log 'removed doc', id, fields
                    # doc_results.pull id
                    self.removed 'docs', id
            )
            
            # for doc_result in doc_results
                
            # user_results = Meteor.users.find(_id:$in:doc_results).observeChanges(
            #     added: (id, fields) ->
            #         # console.log 'added doc', id, fields
            #         self.added 'docs', id, fields
            #     changed: (id, fields) ->
            #         # console.log 'changed doc', id, fields
            #         self.changed 'docs', id, fields
            #     removed: (id) ->
            #         # console.log 'removed doc', id, fields
            #         self.removed 'docs', id
            # )
            
            
            
            # console.log 'doc handle count', subHandle._observeDriver._results
    
            self.ready()
            
            self.onStop ()-> subHandle.stop()

        
        
Meteor.publish 'block', (hash)->
    Docs.find 
        type: 'block'
        hash: hash