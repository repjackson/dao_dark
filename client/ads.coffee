    
# Template.ads.onRendered ->
#     @autorun => Meteor.subscribe 'ads'
    

# Template.ad_page.onCreated ->
#     @autorun => Meteor.subscribe 'block', @hash
    

# Template.ad_page.helpers
#     ad: -> Docs.findOne type:'ad'
        
        