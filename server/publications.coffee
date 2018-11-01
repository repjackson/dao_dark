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
    

# Meteor.publish 'facet', (
#     selected_tags
#     selected_keywords
#     selected_concepts
#     selected_entities
#     selected_author_ids=[]
#     selected_location_tags
#     selected_timestamp_tags
#     type
#     author_id
#     )->
    
#         self = @
#         match = {}
        
#         # match.tags = $all: selected_tags
#         if type then match.type = type
#         # console.log selected_timestamp_tags

#         # if view_private is true
#         #     match.author_id = Meteor.userId()
        
#         # if view_private is false
#         #     match.published = $in: [0,1]

#         if selected_tags.length > 0 then match.tags = $all: selected_tags

#         if selected_author_ids.length > 0 
#             match.author_id = $in: selected_author_ids
#         if selected_location_tags.length > 0 then match.location_tags = $all: selected_location_tags
#         if selected_keywords.length > 0 then match.watson_keywords = $all: selected_keywords
#         if selected_concepts.length > 0 then match.watson_concepts = $all: selected_concepts
#         if selected_entities.length > 0 then match.watson_entities = $all: selected_entities
#         if selected_timestamp_tags.length > 0 then match.timestamp_tags = $all: selected_timestamp_tags
        

#         # if view_private is true then match.author_id = @userId
#         # if view_resonates?
#         #     if view_resonates is true then match.favoriters = $in: [@userId]
#         #     else if view_resonates is false then match.favoriters = $nin: [@userId]
#         # if view_read?
#         #     if view_read is true then match.read_by = $in: [@userId]
#         #     else if view_read is false then match.read_by = $nin: [@userId]
#         # if view_published is true
#         #     match.published = $in: [1,0]
#         # else if view_published is false
#         #     match.published = -1
#         #     match.author_id = Meteor.userId()
            
#         # if view_bookmarked?
#         #     if view_bookmarked is true then match.bookmarked_ids = $in: [@userId]
#         #     else if view_bookmarked is false then match.bookmarked_ids = $nin: [@userId]
#         # if view_complete? then match.complete = view_complete
#         # console.log view_complete
        
        
        
#         # match.site = Meteor.settings.public.site

#         # console.log 'match:', match
#         # if view_images? then match.components?.image = view_images
        
#         # lightbank types
#         # if view_lightbank_type? then match.lightbank_type = view_lightbank_type
#         # match.lightbank_type = $ne:'journal_prompt'
        
#         # ancestor_ids_cloud = Docs.aggregate [
#         #     { $match: match }
#         #     { $project: ancestor_array: 1 }
#         #     { $unwind: "$ancestor_array" }
#         #     { $group: _id: '$ancestor_array', count: $sum: 1 }
#         #     { $match: _id: $nin: selected_ancestor_ids }
#         #     { $sort: count: -1, _id: 1 }
#         #     { $limit: limit }
#         #     { $project: _id: 0, name: '$_id', count: 1 }
#         #     ]
#         # # console.log 'theme ancestor_ids_cloud, ', ancestor_ids_cloud
#         # ancestor_ids_cloud.forEach (ancestor_id, i) ->
#         #     self.added 'ancestor_ids', Random.id(),
#         #         name: ancestor_id.name
#         #         count: ancestor_id.count
#         #         index: i

#         theme_tag_cloud = Docs.aggregate [
#             { $match: match }
#             { $project: tags: 1 }
#             { $unwind: "$tags" }
#             { $group: _id: '$tags', count: $sum: 1 }
#             { $match: _id: $nin: selected_tags }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 20 }
#             { $project: _id: 0, name: '$_id', count: 1 }
#             ]
#         # console.log 'theme theme_tag_cloud, ', theme_tag_cloud
#         theme_tag_cloud.forEach (tag, i) ->
#             self.added 'tags', Random.id(),
#                 name: tag.name
#                 count: tag.count
#                 index: i



#         watson_keyword_cloud = Docs.aggregate [
#             { $match: match }
#             { $project: watson_keywords: 1 }
#             { $unwind: "$watson_keywords" }
#             { $group: _id: '$watson_keywords', count: $sum: 1 }
#             { $match: _id: $nin: selected_tags }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 20 }
#             { $project: _id: 0, name: '$_id', count: 1 }
#             ]
#         # console.log 'watson cloud, ', watson_keyword_cloud
#         watson_keyword_cloud.forEach (keyword, i) ->
#             self.added 'watson_keywords', Random.id(),
#                 name: keyword.name
#                 count: keyword.count
#                 index: i
        
        
#         watson_concept_cloud = Docs.aggregate [
#             { $match: match }
#             { $project: watson_concepts: 1 }
#             { $unwind: "$watson_concepts" }
#             { $group: _id: '$watson_concepts', count: $sum: 1 }
#             { $match: _id: $nin: selected_tags }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 20 }
#             { $project: _id: 0, name: '$_id', count: 1 }
#             ]
#         # console.log 'watson cloud, ', watson_concept_cloud
#         watson_concept_cloud.forEach (concept, i) ->
#             self.added 'watson_concepts', Random.id(),
#                 name: concept.name
#                 count: concept.count
#                 index: i

#         timestamp_tags_cloud = Docs.aggregate [
#             { $match: match }
#             { $project: timestamp_tags: 1 }
#             { $unwind: "$timestamp_tags" }
#             { $group: _id: '$timestamp_tags', count: $sum: 1 }
#             { $match: _id: $nin: selected_timestamp_tags }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 10 }
#             { $project: _id: 0, name: '$_id', count: 1 }
#             ]
#         # console.log 'timestamp_tags_cloud, ', timestamp_tags_cloud
#         timestamp_tags_cloud.forEach (timestamp_tag, i) ->
#             self.added 'timestamp_tags', Random.id(),
#                 name: timestamp_tag.name
#                 count: timestamp_tag.count
#                 index: i
    
    
#         # entities_tags_cloud = Docs.aggregate [
#         #     { $match: match }
#         #     { $project: entities_tags: 1 }
#         #     { $unwind: "$entities_tags" }
#         #     { $group: _id: '$entities_tags', count: $sum: 1 }
#         #     { $match: _id: $nin: selected_entities_tags }
#         #     { $sort: count: -1, _id: 1 }
#         #     { $limit: 10 }
#         #     { $project: _id: 0, name: '$_id', count: 1 }
#         #     ]
#         # # console.log 'entities_tags_cloud, ', entities_tags_cloud
#         # entities_tags_cloud.forEach (entities_tag, i) ->
#         #     self.added 'entities_tags', Random.id(),
#         #         name: entities_tag.name
#         #         count: entities_tag.count
#         #         index: i
    
    
#         # intention_tag_cloud = Docs.aggregate [
#         #     { $match: match }
#         #     { $project: intention_tags: 1 }
#         #     { $unwind: "$intention_tags" }
#         #     { $group: _id: '$intention_tags', count: $sum: 1 }
#         #     { $match: _id: $nin: selected_intention_tags }
#         #     { $sort: count: -1, _id: 1 }
#         #     { $limit: 20 }
#         #     { $project: _id: 0, name: '$_id', count: 1 }
#         #     ]
#         # # console.log 'intention intention_tag_cloud, ', intention_tag_cloud
#         # intention_tag_cloud.forEach (intention_tag, i) ->
#         #     self.added 'intention_tags', Random.id(),
#         #         name: intention_tag.name
#         #         count: intention_tag.count
#         #         index: i

    
#         location_tag_cloud = Docs.aggregate [
#             { $match: match }
#             { $project: location_tags: 1 }
#             { $unwind: "$location_tags" }
#             { $group: _id: '$location_tags', count: $sum: 1 }
#             { $match: _id: $nin: selected_location_tags }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 20 }
#             { $project: _id: 0, name: '$_id', count: 1 }
#             ]
#         # console.log 'location location_tag_cloud, ', location_tag_cloud
#         location_tag_cloud.forEach (location_tag, i) ->
#             self.added 'location_tags', Random.id(),
#                 name: location_tag.name
#                 count: location_tag.count
#                 index: i


#         author_match = match
#         # author_match.published = 1
    
#         author_tag_cloud = Docs.aggregate [
#             { $match: author_match }
#             { $project: author_id: 1 }
#             { $group: _id: '$author_id', count: $sum: 1 }
#             { $match: _id: $nin: selected_author_ids }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 20 }
#             { $project: _id: 0, text: '$_id', count: 1 }
#             ]
    
    
#         # console.log author_tag_cloud
        
#         # author_objects = []
#         # Meteor.users.find _id: $in: author_tag_cloud.
    
#         author_tag_cloud.forEach (author_id) ->
#             self.added 'author_ids', Random.id(),
#                 text: author_id.text
#                 count: author_id.count

#         # found_docs = Docs.find(match).fetch()
#         # console.log 'match', match
#         # console.log 'found_docs', found_docs
#         # found_docs.forEach (found_doc) ->
#         #     self.added 'docs', doc._id, fields
#         #         text: author_id.text
#         #         count: author_id.count
        
#         # doc_results = []
#         subHandle = Docs.find(match, {limit:20, sort: timestamp:-1}).observeChanges(
#             added: (id, fields) ->
#                 # console.log 'added doc', id, fields
#                 # doc_results.push id
#                 self.added 'docs', id, fields
#             changed: (id, fields) ->
#                 # console.log 'changed doc', id, fields
#                 self.changed 'docs', id, fields
#             removed: (id) ->
#                 # console.log 'removed doc', id, fields
#                 # doc_results.pull id
#                 self.removed 'docs', id
#         )
        
#         # for doc_result in doc_results
            
#         # user_results = Meteor.users.find(_id:$in:doc_results).observeChanges(
#         #     added: (id, fields) ->
#         #         # console.log 'added doc', id, fields
#         #         self.added 'docs', id, fields
#         #     changed: (id, fields) ->
#         #         # console.log 'changed doc', id, fields
#         #         self.changed 'docs', id, fields
#         #     removed: (id) ->
#         #         # console.log 'removed doc', id, fields
#         #         self.removed 'docs', id
#         # )
        
        
        
#         # console.log 'doc handle count', subHandle

#         self.ready()
        
#         self.onStop ()-> subHandle.stop()


Meteor.publish 'me', ->
    Meteor.users.find @userId

Meteor.publish 'type', (type, limit)->
    if limit
        limit_val = limit
    else
        limit_val = 100
    Docs.find {type:type},
        {
            limit:limit_val
            sort: timestamp:-1
        }


Meteor.publish 'single_doc', (doc_id)->
    Docs.find doc_id
