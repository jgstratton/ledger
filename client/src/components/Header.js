import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import * as actions from '../actions';

const NavListLink = ({ to, children }) => (
    <li className="nav-item">
        <Link className="nav-link" to={to}>
            {children}
        </Link>
    </li>
);

const NavDropLink = ({ to, children }) => (
    <Link className="dropdown-item" to={to}>
        {children}
    </Link>
);

class Header extends Component {
    render() {
        return (
            <header className="bg-dark">
                <div className="center-content">
                    <nav className="navbar navbar-expand-md navbar-dark bg-dark">
                        <div>
                            <button
                                className="navbar-toggler collapsed"
                                type="button"
                                data-toggle="collapse"
                                data-target="##navbar"
                            >
                                <i className="fa fa-bars" />
                            </button>
                            <span className="navbar-brand">My checkbook</span>
                        </div>
                        {this.props.loggedIn && (
                            <div className="text-right flex-nowrap d-flex d-md-none text-secondary">
                                Summary -{' '}
                                <span className="badge badge-primary text-nowrap">
                                    #moneyFormat(rc.user.getSummaryBalance())#
                                </span>
                            </div>
                        )}
                        {this.props.loggedIn && (
                            <div className="navbar-collapse collapse" id="navbar">
                                <ul className="navbar-nav mr-auto">
                                    <NavListLink to="./Accounts">Accounts</NavListLink>
                                    <NavListLink to="#buildUrl('transfer.new')#">Transfer</NavListLink>
                                    <NavListLink to="#buildUrl('transactionSearch.search')#">Search</NavListLink>
                                    <li className="nav-item dropdown">
                                        <a className="nav-link dropdown-toggle" data-toggle="dropdown">
                                            Other Features
                                        </a>
                                        <div className="dropdown-menu">
                                            <NavDropLink to="#buildUrl('schedular.autoPaymentList')#">
                                                Automatic Payments
                                            </NavDropLink>
                                            <NavDropLink to="#buildUrl('user.checkbookRounding')#">
                                                Add Auto Rounding
                                            </NavDropLink>
                                            <NavDropLink to="#buildUrl('category.manageCategories')#">
                                                Manage Categories
                                            </NavDropLink>
                                            <NavDropLink to="TRN_300.php">Cost Breakdown</NavDropLink>
                                            {process.env.NODE_ENV === 'development' && (
                                                <NavDropLink to="#buildUrl('admin.devToggles')#">
                                                    Dev toggles
                                                </NavDropLink>
                                            )}
                                        </div>
                                    </li>

                                    <li className="nav-item">
                                        <Link to="/login" onClick={this.props.logoutUser} className="nav-link">
                                            Logout
                                        </Link>
                                    </li>
                                </ul>
                            </div>
                        )}
                        {this.props.loggedIn && (
                            <div className="text-right d-none d-md-inline text-secondary">
                                Checkbook Summary -{' '}
                                <span className="badge badge-primary">{'$' + this.props.summary}</span>
                            </div>
                        )}
                    </nav>

                    <div className="title-bar">
                        <hr />
                        {/*
                <cfif request.section eq "transaction" or (request.section eq 'transfer' and request.item eq 'edit')>
                    #view('transaction/_header')#
                </cfif>
                */}
                    </div>
                </div>
            </header>
        );
    }
}

function mapStateToProps(state) {
    const user = state.user;
    return user;
}

export default connect(
    mapStateToProps,
    actions
)(Header);
