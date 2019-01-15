import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.nav.onCreated ->
    @autorun => Meteor.subscribe 'users'

Template.nav.helpers
    user: -> Meteor.users.findOne username:FlowRouter.getParam('username')

Template.nav.events
    'click .logout': -> Meteor.logout()

    'click .invert': ->
        Session.set('invert', !Session.get('invert'))