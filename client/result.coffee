Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id
    Meteor.setTimeout ->
        $('.ui.progress').progress();
    , 500

                
Template.result.helpers
    result: ->
        Docs.findOne
            _id: Template.currentData()._id


    calculated_size: ()->
        # console.log typeof parseFloat(@relevance)
        # console.log typeof (@relevance*100).toFixed()
        whole = parseInt @relevance*10
        
        if whole is 2 then 'f2'
        else if whole is 3 then 'f3'
        else if whole is 4 then 'f4'
        else if whole is 5 then 'f5'
        else if whole is 6 then 'f6'
        else if whole is 7 then 'f7'
        else if whole is 8 then 'f8'
        else if whole is 9 then 'f9'
        else if whole is 10 then 'f10'