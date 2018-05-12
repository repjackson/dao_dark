if Meteor.isClient
    FlowRouter.route '/reddit', action: ->
        BlazeLayout.render 'layout', 
            main: 'reddit'
    
    Template.reddit.onCreated ->
        @autorun -> Meteor.subscribe('reddit')
    
    # Template.reddit.onRendered ->
    #     Meteor.setTimeout ->
    #         $('.ui.accordion').accordion()
    #     , 400

    
    
    Template.reddit.helpers
        reddit_posts: ->
            Docs.find
                site:'reddit'
            
        
    Template.reddit.events
        'click #call_reddit': ->
            Meteor.call 'call_reddit', 'technology', (err,res)->
                if err then console.error err
                else
                    console.log res
                    
                    
if Meteor.isServer
    Meteor.pubilsh 'reddit', ->
        Docs.find
            site:'reddit'
            
            
            