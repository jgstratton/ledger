import axios from 'axios';

//actions
export const FETCH_USER = 'fetch_user';

export const fetchUser = () => async dispatch => {
    let user = {
        loggedIn: false,
        id: 0,
        email: ''
    };
    try {
        const res = await axios.get('/api/user');
        if (typeof res.data.data.user != 'undefined') {
            user = res.data.data.user;
            user.loggedIn = true;
        }
    } catch (error) {
        if (error.response.status != 401) {
            console.log(error.response);
        }
    }

    dispatch({ type: FETCH_USER, payload: user });
};

export const FETCH_SUMMARY = 'fetch_summary';

export const fetchSummary = () => async dispatch => {
    let summary = 0;
    try {
        const res = await axios.get('/api/user/summary');

        if (typeof res.data.data.summary != 'undefined') {
            summary = res.data.data.summary;
        }
    } catch (error) {
        if (error.response.status != 401) {
            console.log(error.response);
        }
    }

    dispatch({ type: FETCH_SUMMARY, payload: summary });
};
