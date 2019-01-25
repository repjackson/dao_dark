import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


Template.edit.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('id')
    @autorun -> Meteor.subscribe 'schema', FlowRouter.getParam('id')

    
Template.view.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('id')
    @autorun -> Meteor.subscribe 'schema', FlowRouter.getParam('id')

Template.edit.events
    'blur .body': (e,t)->
        body = t.$('.body').val()
        Docs.update FlowRouter.getParam('id'),
            $set:body:body


    'click .toggle_complete': (e,t)->
        Docs.update FlowRouter.getParam('id'),
            $set:complete:!@complete


    'click .delete': ->
        if confirm 'confirm delete'
            Docs.remove @_id
            FlowRouter.go '/'

