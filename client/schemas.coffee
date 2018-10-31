FlowRouter.route '/schemas',
    name:'schemas'
    action: ->
        BlazeLayout.render 'layout',
            main: 'schemas'
