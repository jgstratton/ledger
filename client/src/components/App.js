import React, { Component } from 'react';
import { connect } from 'react-redux';
import Header from './Header';
import Accounts from './Accounts';
import NotFound404 from './NotFound404';
import * as actions from '../actions';

import { BrowserRouter, Route, Switch } from 'react-router-dom';

class App extends Component {
    componentDidMount() {
        this.props.fetchUser();
        this.props.fetchSummary();
    }
    render() {
        return (
            <BrowserRouter>
                <div className="App">
                    <Header />
                    <Switch>
                        <Route exact path="/accounts" component={Accounts} />
                        <Route component={NotFound404} />
                    </Switch>
                </div>
            </BrowserRouter>
        );
    }
}

export default connect(
    null,
    actions
)(App);
