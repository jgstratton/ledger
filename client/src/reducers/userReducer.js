import { FETCH_USER } from '../actions';
import { FETCH_SUMMARY } from '../actions';
import { LOGOUT_USER } from '../actions';

export default function(state = {}, action) {
    switch (action.type) {
        case FETCH_USER:
            return {
                ...state,
                loggedIn: action.payload.loggedIn,
                id: action.payload.id,
                email: action.payload.email
            };
        case FETCH_SUMMARY:
            return {
                ...state,
                summary: action.payload
            };
        case LOGOUT_USER:
            return {
                ...state,
                loggedIn: false,
                id: 0,
                email: '',
                summary: 0
            };
        default:
            return state;
    }
}
