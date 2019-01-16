import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.task.onCreated ->
    @autorun => Meteor.subscribe 'type', 'task'

Template.task.events
    'click .add_task': ->
        new_task_id = 
            Docs.insert 
                type:'task'
                bricks: [
                    'title'
                    'user_assignment'
                    'date'
                    'tags'
                    'textarea'
                    ]
        FlowRouter.go "/edit/#{new_task_id}"            
            
Template.task.helpers
    tasks: -> Docs.find type:'task'
    
    
    
