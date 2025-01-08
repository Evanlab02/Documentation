# pg_prepare

(PHP 5 >= 5.1.0, PHP 7, PHP 8)

pg_prepare — Submits a request to the server to create a prepared statement with the given parameters, and waits for completion

## Description

**pg_prepare()** creates a prepared statement for later execution with [pg_execute()](https://devdocs.io/php/function.pg-execute) or [pg_send_execute()](https://devdocs.io/php/function.pg-send-execute). This feature allows commands that will be used repeatedly to be parsed and planned just once, rather than each time they are executed. **pg_prepare()** is supported only against PostgreSQL 7.4 or higher connections; it will fail when using earlier versions.

The function creates a prepared statement named `stmtname` from the `query` string, which must contain a single SQL command. `stmtname` may be `""` to create an unnamed statement, in which case any pre-existing unnamed statement is automatically replaced; otherwise it is an error if the statement name is already defined in the current session. If any parameters are used, they are referred to in the `query` as `$1`, `$2`, etc.

Prepared statements for use with **pg_prepare()** can also be created by executing SQL `PREPARE` statements. (But **pg_prepare()** is more flexible since it does not require parameter types to be pre-specified.) Also, although there is no PHP function for deleting a prepared statement, the SQL `DEALLOCATE` statement can be used for that purpose.

## Parameters

### `connection`

An [PgSql\Connection](https://devdocs.io/php/class.pgsql-connection) instance. When `connection` is unspecified, the default connection is used. The default connection is the last connection made by [pg_connect()](https://devdocs.io/php/function.pg-connect) or [pg_pconnect()](https://devdocs.io/php/function.pg-pconnect).

**Warning**

As of PHP 8.1.0, using the default connection is deprecated.

### `stmtname`

The name to give the prepared statement. Must be unique per-connection. If `""` is specified, then an unnamed statement is created, overwriting any previously defined unnamed statement.

### `query`

The parameterized SQL statement. Must contain only a single statement (multiple statements separated by semi-colons are not allowed). If any parameters are used, they are referred to as `$1`, `$2`, etc.
## Return Values

An [PgSql\Result](https://devdocs.io/php/class.pgsql-result) instance on success, or **`[false](https://www.php.net/manual/en/reserved.constants.php#constant.false)`** on failure.

## Changelog

|Version|Description|
|---|---|
|8.1.0|Returns an [PgSql\Result](https://devdocs.io/php/class.pgsql-result) instance now; previously, a [resource](https://devdocs.io/php/language.types.resource) was returned.|
|8.1.0|The `connection` parameter expects an [PgSql\Connection](https://devdocs.io/php/class.pgsql-connection) instance now; previously, a [resource](https://devdocs.io/php/language.types.resource) was expected.|

## Examples

```php
<?php

// Connect to a database named "mary"
$dbconn = pg_connect("dbname=mary");

// Prepare a query for execution
$result = pg_prepare($dbconn, "my_query", 'SELECT * FROM shops WHERE name = $1');

// Execute the prepared query.  Note that it is not necessary to escape
// the string "Joe's Widgets" in any way
$result = pg_execute($dbconn, "my_query", array("Joe's Widgets"));

// Execute the same prepared query, this time with a different parameter
$result = pg_execute($dbconn, "my_query", array("Clothes Clothes Clothes"));

?>
```

## See Also

- [pg_execute()](https://devdocs.io/php/function.pg-execute) - Sends a request to execute a prepared statement with given parameters, and waits for the result
- [pg_send_execute()](https://devdocs.io/php/function.pg-send-execute) - Sends a request to execute a prepared statement with given parameters, without waiting for the result(s)
