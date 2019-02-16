Template.view_section.events
    'click .view_section': ->
        # console.log @
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', @slug, ->
            Session.set 'loading', false
            
            
            
Template.enter_site.events
    'click .enter_site': ->
        console.log @
