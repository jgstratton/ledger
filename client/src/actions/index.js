import axios from 'axios';

//actions
export const FETCH_USER = 'fetch_user';

export const fetchUser = () => async dispatch => {
    let user = {
        loggedIn: false
    };
    try {
        const res = await axios.get('/api/user');
        user = res.data.data.user;
        user.loggedIn = true;
    } catch (error) {
        if (error.response.status != 401) {
            console.log(error.response);
        }
    }

    dispatch({ type: FETCH_USER, payload: user });
};
