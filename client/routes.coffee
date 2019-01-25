import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


FlowRouter.route '/',
  action: -> @render 'layout','delta'


FlowRouter.route '/dash',
  action: -> @render 'layout','dash'

FlowRouter.route '/edit/:id',
  action: -> @render 'layout','edit'



FlowRouter.route '*', action: ->
  @render 'notFound'
