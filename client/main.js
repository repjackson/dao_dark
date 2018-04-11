import {Meteor} from 'meteor/meteor';
import {Vue} from 'meteor/akryum:vue';
import Vuetify from 'vuetify';

import 'vuetify/dist/vuetify.min.css'
import 'vuetify/dist/vuetify.min.js' 

import App from '/imports/ui/App.vue';

Vue.use(Vuetify);
// console.log(Vue)
// console.log(Vuetify)


Meteor.startup(() => {
  new Vue(App).$mount(document.body);
})