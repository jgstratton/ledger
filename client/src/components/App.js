import React, { Component } from 'react';
import { connect } from 'react-redux';
import Header from './Header';
import Accounts from './Accounts';
import LoginPage from './LoginPage';
import NotFound404 from './NotFound404';
import * as actions from '../actions';

import { BrowserRouter, Route, Switch, Redirect } from 'react-router-dom';

const Page = ({ children }) => (
    <main>
        <div className="center-content">
            <div className="container-fluid inner-content">{children}</div>
        </div>
    </main>
);

//Redirect to login page when authentication is required and user is not logged in
function PrivateRoute({ component: Component, loggedIn, ...rest }) {
    return (
        <Route {...rest} render={props => (loggedIn === true ? <Component {...props} /> : <Redirect to="/login" />)} />
    );
}

//Redirect to accounts page if user tries to access a public-only page while logged in
function PublicRoute({ component: Component, loggedIn, ...rest }) {
    console.log('public route', loggedIn);
    return (
        <Route
            {...rest}
            render={props => (loggedIn === false ? <Component {...props} /> : <Redirect to="/accounts" />)}
        />
    );
}

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
                    <Page>
                        <Switch>
                            <PublicRoute loggedIn={this.props.loggedIn} exact path="/login" component={LoginPage} />
                            <PrivateRoute loggedIn={this.props.loggedIn} exact path="/accounts" component={Accounts} />
                            <Route component={NotFound404} />
                        </Switch>
                    </Page>
                </div>
            </BrowserRouter>
        );
    }
}

function mapStateToProps(state) {
    return state.user;
}

export default connect(
    mapStateToProps,
    actions
)(App);
