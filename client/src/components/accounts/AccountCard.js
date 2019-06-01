import React, { Component } from 'react';
import { Link } from 'react-router-dom';

const moneyFormat = function(val) {
    return val;
};

const badgeClass = function(inSummary) {
    return inSummary ? 'badge-success' : '';
};

const SubAccountRows = ({ subAccounts, children }) => {
    if (subAccounts) {
        return subAccounts.map(subAccount => (
            <SubAccountRow key={subAccount.id} subAccount>
                {children}
            </SubAccountRow>
        ));
    }
    return '';
};

const SubAccountRow = ({ subAccount: { name, inSummary, balance } }) => (
    <div className="row">
        <div className="col-9">
            <Link className="btn btn-link" to="TransactionListing">
                {name}
            </Link>
        </div>
        <div className="col-3 text-right ">
            <span className={'badge ' + badgeClass(inSummary)}>{moneyFormat(balance)}</span>
        </div>
    </div>
);

class AccountCard extends Component {
    render() {
        const { account } = this.props;
        if (account) {
            return (
                <div className="card">
                    <div className="card-header h6">
                        <i className={'fa fa-fw ' + account.iconClass} />
                        {account.name}
                        <div className="pull-right text-right">
                            <h4>{moneyFormat(account.linkedBalance)}</h4>
                        </div>
                    </div>
                    <div className="card-body">
                        <div className="row">
                            <div className="col-9">
                                <Link className="btn btn-link" to="TransactionList">
                                    {account.name}
                                </Link>
                            </div>
                            <div className="col-3 text-right">
                                <span className={'badge ' + badgeClass(account.badgeClass)}>
                                    {moneyFormat(account.balance)}
                                </span>
                            </div>
                        </div>

                        <SubAccountRows subAccounts={account.subAccounts} />

                        <hr />
                        <div className="text-muted font-weight-light">
                            Verified account total:
                            <span className="pull-right">{moneyFormat(account.verifiedLinkedBalance)}</span>
                        </div>
                    </div>
                </div>
            );
        }
        return '';
    }
}

export default AccountCard;
