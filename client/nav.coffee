Template.nav.events
    'click .me': ->
        Meteor.users.update Meteor.userId(),
            $set:page:'me'