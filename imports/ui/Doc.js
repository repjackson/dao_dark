import React, { Component } from 'react'
import { Meteor } from 'meteor/meteor'
import classnames from 'classnames'

import { Docs } from '../api/docs.js'

export default class Doc extends Component {
  constructor(props) {
    super(props)
    // console.log(props)
  }
  
  toggleChecked() {
    // set the checked property to the opposite of its current value
    Meteor.call('docs.setChecked', this.props.doc._id, !this.props.doc.checked)
  }
  deleteThisDoc() {
    Meteor.call('docs.remove', this.props.doc._id)
  }

  togglePrivate() {
    Meteor.call('docs.setPrivate', this.props.doc._id, !this.props.doc.private)
  }


  render() {
    // give tasks a different className when they are checked off,
    // so that we can style them nicely in css
    // const taskClassName = this.prtask.checked ? 'checked' : ''
    const docClassName = classnames({
      checked: this.props.doc.checked,
      private: this.props.doc.private,
    })
    // console.log(this.props.doc._id)

    return (
      <div>
        <li className = { docClassName } >
        {/* <button className="delete" onClick={this.deleteThisDoc.bind(this)}>x</button> 
  
      
        <input type = "checkbox"
        readOnly checked = {!!this.props.doc.checked } onClick = { this.toggleChecked.bind(this) }
        />
        */}
  
        {
          this.props.showPrivateButton ? (
            <button className="toggle-private" onClick={this.togglePrivate.bind(this)}>
              { this.props.task.private ? 'Private' : 'Public' }
            </button>
          ) : ''
        }
  
        <span className="text">
          <ul>
            {
              this.props.doc.tags.map((tag) => {
                return(
                  <li key={tag}>{tag}</li>
                )
              } 
              )
            }
          </ul>
              
              
            <strong>{this.props.doc._id}</strong>
          </span>
        </li>
      </div>
    )
  }
}
