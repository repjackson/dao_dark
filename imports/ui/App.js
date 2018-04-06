import React, { Component } from 'react';
import ReactDOM from 'react-dom'
import { withTracker } from 'meteor/react-meteor-data';

import { Docs } from '../api/docs.js'
import Doc from './Doc.js'

import Button from 'material-ui/Button'


class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      test_session: true
    };
  }

  handleSubmit(event) {
    event.preventDefault()
    const text = ReactDOM.findDOMNode(this.refs.textInput).value.trim()

    console.log(text)
    Meteor.call('docs.insert', text)

    ReactDOM.findDOMNode(this.refs.textInput).value = ''

  }

  renderDocs() {
    // console.log(this.props.docs)
    return this.props.docs.map((doc) => {

      return (
        <Doc
          key = { doc._id }
          doc = { doc }
        />
      )
    })
  }

  render() {
    return (
      <div className="container">
        <header>
          <h1>dao</h1>
          <Button variant="raised" color="primary">
            Hello World
          </Button>

          <form className='new-doc' onSubmit={this.handleSubmit.bind(this)}>
            <input
              type='text'
              ref='textInput'
              placeholder='add doc'
            />
          </form>
        </header>
        <h3>Docs:</h3>
        <ul>
          {this.renderDocs()}
        </ul>
      </div>
    )
  }
}

export default withTracker(() => {
  const docsSub = Meteor.subscribe('docs')

  return {
    loading: !docsSub.ready(),
    currentUser: Meteor.user(),
    docs: Docs.find({}).fetch(),
  };
})(App);
