import { Meteor } from 'meteor/meteor';
import { FlowRouter } from 'meteor/kadira:flow-router';
// import { BlazeLayout } from 'meteor/kadira:blaze-layout';
import { Vue } from 'meteor/akryum:vue';
import { $ } from 'meteor/jquery';

import Layout from '/imports/ui/layouts/layout.vue';

$('body').append('<div id="_vue_root"></div>');
// Add an element on body for Vue to mount.
// Of course you can use direct DOM operations there to avoid jQuery.
Meteor.vueVm = new Vue({ // Attach vm to Meteor, in case we need it elsewhere.
  el: '#_vue_root',
  render(createElement) {
    return createElement(Layout, { attrs: { type: this.type, body: this.body } });
  },
  // The render function above acts as:
  // <layout :type="type" :body="body"></layout>
  data: () => ({ type: '', body: '' }),
  components: { Layout },
});
const render = (type, body) => { // In place of BlazeLayout.render
  Meteor.vueVm.type = type;
  Meteor.vueVm.body = body;
};