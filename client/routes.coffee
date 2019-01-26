import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


FlowRouter.route '/', action: -> @render 'layout','delta'

FlowRouter.route '/people', action: -> @render 'layout','people'

FlowRouter.route '/enter', action: -> @render 'layout','enter'
FlowRouter.route '/me', action: -> @render 'layout','me'
  
  
FlowRouter.route '/dash', action: -> @render 'layout','dash'

FlowRouter.route '/edit/:id', action: -> @render 'layout','edit'
FlowRouter.route '/view/:id', action: -> @render 'layout','view'



FlowRouter.route '*', action: -> @render 'not_found'
