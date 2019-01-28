import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.nav.onCreated ->
    @autorun => Meteor.subscribe 'users'

Template.nav.helpers
    user: -> Meteor.users.findOne username:FlowRouter.getParam('username')

Template.nav.events
    'click .logout': -> Meteor.logout()

    'click .toggle_invert': ->
        Session.set('invert', !Session.get('invert'))

    'click .add': ->
        new_id = Docs.insert {}
        FlowRouter.go "/edit/#{new_id}"
