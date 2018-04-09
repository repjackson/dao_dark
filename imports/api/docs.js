import { Meteor } from 'meteor/meteor';
import { Mongo } from 'meteor/mongo';
import { check } from 'meteor/check';

export const Docs = new Mongo.Collection('docs');

if (Meteor.isServer) {
  // this code only runs on the server
  Meteor.publish('docs', function docsPublication() {
    return Docs.find({
      // $or: [//   { private: { $ne: true } },
      //   { owner: this.userId },
      // ],
    }, { limit: 10 });
  });
}

Meteor.methods({
  'docs.insert' (text) {
    // make sure the user is logged in before inserting a doc
    // if (!this.userId) {
    //   throw new Meteor.Error('not-authorized');
    // }

    Docs.insert({
      text,
      createdAt: new Date(),
      // owner: this.userId,
      // username: Meteor.users.findOne(this.userId).username,
    });
  },
  'docs.remove' (docId) {
    Docs.remove(docId);
  },
  'docs.setChecked' (docId, setChecked) {
    Docs.update(docId, { $set: { checked: setChecked } });
  },
  'docs.setPrivate' (docId, setToPrivate) {
    const doc = Docs.findOne(docId);

    // make sure only the doc owner can make a doc private
    if (doc.owner !== this.userId) {
      throw new Meteor.Error('not-authorized');
    }

    Docs.update(docId, { $set: { private: setToPrivate } });
  }
});
