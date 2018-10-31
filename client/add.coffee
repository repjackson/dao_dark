FlowRouter.route '/add',
    name:'add'
    action: ->
        BlazeLayout.render 'layout',
            main: 'add'
