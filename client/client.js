import {Meteor} from 'meteor/meteor';
import {Vue} from 'meteor/akryum:vue';
import Vuetify from 'vuetify';

import 'vuetify/dist/vuetify.min.css'
import 'vuetify/dist/vuetify.min.js' 
import { RouterFactory, nativeScrollBehavior } from 'meteor/akryum:vue-router2'

import App from '/imports/ui/App.vue';

const routerFactory = new RouterFactory({
  mode: 'history',
  scrollBehavior: nativeScrollBehavior,
})


Vue.use(Vuetify);
// console.log(Vue)
// console.log(Vuetify)


Meteor.startup(() => {
  
  const router = routerFactory.create()
  
  new Vue({
    router,
    ...App
  }).$mount(document.body);
})