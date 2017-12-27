Meteor.methods 
    add_doc: (tags) ->
        result = Docs.insert
            parent_id: 'jFGwEzNgajnMad2MA'
            tags: tags
            author_id: Meteor.userId()
            timestamp: Date.now()
            published: 1

# Accounts.config
#     forbidClientAccountCreation : true
                

Docs.allow
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> doc.author_id is userId
    remove: (userId, doc) -> doc.author_id is userId


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
                { $limit:42 }
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


Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id