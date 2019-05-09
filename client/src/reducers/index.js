import authReducer from './authReducer';
import { combineReducers } from 'redux';

export default combineReducers({
    user: authReducer
});
