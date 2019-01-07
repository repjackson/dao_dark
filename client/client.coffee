Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.layout.events
    'keyup #quick_add': (e,t)->
        if e.which is 13
            body = t.$('#quick_add').val().toLowerCase().trim()
            new_id = 
                Docs.insert
                    body:body
            console.log Docs.findOne new_id
            t.$('#quick_add').val('')
        
    'click .toggle_filter': ->
        delta = Docs.findOne type:'delta'
        if @name in delta.fi
            Docs.update delta._id, $pull: fi: @name
        else    
            Docs.update delta._id, $addToSet: fi: @name
        Meteor.call 'fum', delta._id, (err,res)->
    

Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'delta'


Template.layout.helpers
    delta: -> 
        Docs.findOne type:'delta'

Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id

    
Template.result.helpers
    result: -> 
        doc = Docs.findOne @_id
        # console.log doc
        doc
    
Template.result.events
    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag = t.$('.new_tag').val().toLowerCase()   
            # Meteor.call 'pull_subreddit', subreddit
            if @tags
                tag_count = @tags.length
            else
                tag_count = 0
            Docs.update @_id,
                $addToSet: 
                    tags: tag
                $set:tag_count:tag_count
            t.$('.new_tag').val('')    
                
                
    'click .remove_tag': (e,t)->
        current_id = Template.currentData()._id
        new_tag_val = t.$('.new_tag').val()
        unless new_tag_val
            Docs.update current_id,
                $pull:tags:@valueOf()
            t.$('.new_tag').val(@valueOf())    
            
        
    
    'click .remove_doc': ->
        current_id = Template.currentData()._id
        Docs.remove current_id,
    
    
Template.layout.helpers
    filtering_res: ->
        delta = Docs.findOne type:'delta'
        filtering_res = []
        # console.log delta.fo
        for filter in delta.fo
            if filter.name in delta.fi
                filtering_res.push filter
            else if filter.count < delta.total
                filtering_res.push filter
        filtering_res

    

    toggle_value_class: ->
        delta = Docs.findOne type:'delta'
        if delta.fi.length > 0 and @name in delta.fi
            'grey'
        else ''
    
    