import React, { Component } from 'react';
import AccountCard from './AccountCard';
import axios from 'axios';

/*
const dummyData = {
    id: 1,
    name: 'Test Account',
    iconClass: 'fa-money',
    balance: '1000.10',
    linkedBalance: '1050.10',
    verifiedLinkedBalance: '2505.25',
    inSummary: false,
    subAccounts: [
        {
            id: 2,
            name: 'test sub account',
            inSummary: true,
            balance: 50
        }
    ]
};
*/

const AccountCards = ({ accounts, children }) => {
    if (accounts) {
        return accounts.map(account => (
            <div className="col-lg-6 mb-3">
                <AccountCard key={account.id} account={account}>
                    {children}
                </AccountCard>
            </div>
        ));
    }
    return '';
};

class AccountsPage extends Component {
    state = { loading: true, accounts: [] };

    async componentDidMount() {
        try {
            const res = await axios.get('/api/accounts');
            if (typeof res.data.data.accounts !== 'undefined') {
                this.setState({ loading: false, accounts: res.data.data.accounts });
            }
        } catch (error) {
            if (error.response.status !== 401) {
                console.log(error.response);
            }
        }
        console.log(this.state);
    }

    render() {
        return (
            <div>
                <h1>Accounts</h1>
                <div className="row">
                    <AccountCards accounts={this.state.accounts} />
                </div>
            </div>
        );
    }
}

export default AccountsPage;
