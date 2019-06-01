import React, { Component } from 'react';

class LoginPage extends Component {
    render() {
        return (
            <div>
                <p className="text-info">
                    Welcome to <b>My Checkbook</b>!
                </p>
                <a className="btn btn-primary" href={'./auth/proxyLogin?startfb'}>
                    <i className="fa fa-facebook-square" /> Login with Facebook
                </a>
            </div>
        );
    }
}

export default LoginPage;
