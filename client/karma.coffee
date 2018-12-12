Template.karma.events
    'click .add_karma': ->
        Meteor.users.update Meteor.userId(),
            $inc: karma: 1