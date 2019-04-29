import React, { Component } from 'react';
import Header from './Header';
import Accounts from './Accounts';
import NotFound404 from './NotFound404';

import { BrowserRouter, Route, Switch } from 'react-router-dom';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';

class App extends Component {
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

export default App;
