import React, { Component } from 'react';
import './css/App.css';
import Header from './components/Header';
import Accounts from './components/Accounts';
import NotFound404 from './components/NotFound404';

import { BrowserRouter, Route, Switch } from 'react-router-dom';

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
