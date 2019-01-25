import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


Template.edit.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    