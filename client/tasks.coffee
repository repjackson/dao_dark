FlowRouter.route '/tasks', action: ->
    BlazeLayout.render 'layout', 
        main: 'tasks'

Template.tasks.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'task')


Template.tasks.helpers
    tasks: -> Docs.find {type: 'task'}
     
     
Template.tasks.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
     
            
Template.tasks.events
    'click #add_task': ->
        id = Docs.insert
            type: 'task'
        Session.set 'editing_id', id
        
        

Template.task_item.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.task_item.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.task_item.events
    'click #delete': ->
        swal {
            title: 'Delete task?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            doc = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove doc._id, ->
                FlowRouter.go "/tasks"        
                
                
                
    
Template.task.events
    'click #delete': ->
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            bike = Docs.findOne FlowRouter.getParam('bikes_id')
            Docs.remove bike._id, ->
                FlowRouter.go "/tasks"        