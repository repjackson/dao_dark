import React, { Component } from 'react';
import {withTracker} from 'meteor/react-meteor-data';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      test_session: true
    };
  }
  
  render() {
    return (
      <div className="container">
        <h1>hello world</h1>
         
      </div>    
    )
  }
}
  
export default withTracker(() => {

  return {
    currentUser: Meteor.user(),
  };
})(App);