import React, { Component } from 'react';

const fixFacebookReturnUrl = () => {
    if (window.location.hash && window.location.hash == '#_=_') {
        if (window.history && window.history.pushState) {
            window.history.pushState(
                '',
                document.title,
                window.location.pathname
            );
        } else {
            // Prevent scrolling by storing the page's current scroll offset
            var scroll = {
                top: document.body.scrollTop,
                left: document.body.scrollLeft
            };
            window.location.hash = '';
            // Restore the scroll offset, should be flicker free
            document.body.scrollTop = scroll.top;
            document.body.scrollLeft = scroll.left;
        }
    }
};

class LoginPage extends Component {
    componentDidMount() {
        fixFacebookReturnUrl();
    }
    render() {
        return <h1>Login</h1>;
    }
}

export default LoginPage;
