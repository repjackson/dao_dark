        
Template.edit.events
    'blur .title': (e,t)->
        val = t.$('.title').val()
        console.log val
        Docs.update delta.doc_id,
            $set: title:val
    'blur .content': (e,t)->
        val = t.$('.content').val()
        console.log val
        Docs.update delta.doc_id,
            $set: content:val
    'keyup #add_tag': (e,t)->
        if e.which is 13
            val = t.$('#add_tag').val()
            console.log val
            Docs.update delta.doc_id,
                $addToSet: tags:val
        
    'click .remove_tag': (e,t)->
        Docs.update delta.doc_id,
            $pull: tags: @valueOf()