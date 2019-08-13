/**
 * The transaction data service is for access transaction data directly without returning orm objects
 */
component output="false" accessors="true" {
    property userService;
    property name="limitedResultsCount" default=1000;
    property queryUtilService;

    public function init(){
        variables.queryUtilService = new utils.queryUtilService();
    }

    public array function getTransactionData(required account account){
        userService.checkAccount(arguments.account);

        var qryTransactions = queryExecute("
            SELECT *
            FROM
                vw_transactionData
            WHERE 
                account_id = :accountId AND
                isHidden = 0
            ORDER BY 
                transactionDate desc,
                id desc
                LIMIT :limit", 
            {
                accountId: arguments.account.getId(),
                limit: {value=variables.limitedResultsCount, cfsqltype="cf_sql_integer"}
            }
        );

        return queryUtilService.queryToArray(qryTransactions);
    }

    public array function getAccountRunningHistory(required account account) {
        transaction{
            var qryRunningTotals = queryExecute("
                SET @runtot:=0;
                SET @entryNum:=0;

                CREATE TEMPORARY TABLE RunningTotals
                SELECT
                    q1.transactionDate,
                    (@runtot := @runtot + q1.dayTotal) AS balance,
                    (@entryNum := @entryNum + 1) as EntryNum
                FROM
                    (
                        SELECT transactionDate, SUM(signedAmount) AS dayTotal
                        FROM  vw_transactionData vw 
                        LEFT JOIN accounts a on vw.account_id = a.id
                        WHERE  vw.account_id = :accountid or a.linkedAccount = :accountid
                        GROUP  BY transactionDate
                        ORDER BY transactionDate
                    ) AS q1;

                /* Can't use the same temp table twice in 1 query, so i have to duplicated it */
                CREATE TEMPORARY TABLE RunningTotals2
                SELECT transactionDate, balance FROM RunningTotals;

                SELECT 
                    t.transactionDate, 
                    date_format(t.transactionDate,'%Y-%m-%d') as x, 
                    t.balance, 
                    avg(t_past.balance) as y
                FROM RunningTotals t
                INNER JOIN RunningTotals2 as t_past 
                    ON t_past.transactionDate between t.transactionDate - 90 and t.transactionDate
                WHERE t.transactionDate > '2012-01-01'
                    AND MOD(EntryNum, 30) = 0
                GROUP BY t.transactionDate, date_format(t.transactionDate,'%Y-%m-%d'), t.balance
                ORDER BY t.transactionDate;

                /* Delete temporary tables */
                DROP TEMPORARY TABLE RunningTotals;
                DROP TEMPORARY TABLE RunningTotals2;
                ",
                {
                    accountId: arguments.account.getId()
                }
            );

        }

        return queryUtilService.queryToArray(qryRunningTotals);
    }
}