Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

        
Template.layout.events
    'keyup #quick_add': (e,t)->
        if e.which is 13
            body = t.$('#quick_add').val()
            new_id = 
                Docs.insert
                    body:body
            console.log Docs.findOne new_id
            t.$('#quick_add').val('')
        

Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'delta'


Template.layout.helpers
    delta: -> 
        Docs.findOne type:'delta'


Template.layout.events
    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag = t.$('.new_tag').val()    
            # Meteor.call 'pull_subreddit', subreddit
            Docs.update @_id,
                $addToSet: tags: tag
            t.$('.new_tag').val('')    
                
                

    'click .toggle_filter': ->
        delta = Docs.findOne type:'delta'
        if @name in delta.fi
            Docs.update delta._id, $pull: fi: @name
        else    
            Docs.update delta._id, $addToSet: fi: @name
        Meteor.call 'fum', delta._id, (err,res)->
    


    
Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data._id

    
Template.result.helpers
    result: -> 
        doc = Docs.findOne @_id
        console.log doc
        doc
    
Template.result.events
    'click .remove_tag': ->
        current_id = Template.currentData()._id
        Docs.update current_id,
            $pull:tags:@valueOf()
    
    'click .remove': ->
        current_id = Template.currentData()._id
        Docs.remove current_id,
    
    
Template.layout.helpers
    filtering_res: ->
        delta = Docs.findOne type:'delta'
        filtering_res = []
        # console.log delta.fo
        for filter in delta.fo
            # if filter.count < delta.total
            filtering_res.push filter
        filtering_res

    

    toggle_value_class: ->
        delta = Docs.findOne type:'delta'
        if delta.fi.length > 0 and @name in delta.fi
            'grey'
        else ''
    
    