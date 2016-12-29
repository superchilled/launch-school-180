# PostgreSQL Data Types - Exercises

1. Describe the difference between the varchar and text data types.

`VARCHAR` is a varaiable-length character type with a specific length limit applied when the column is defined, e.g. `VARCHAR(25)`. IF an attempt is made to store a string longer than the specified limit, and error will be thrown. The maximum possible length of the `VARCHAR` type is 255 characters.

`TEXT` is also a varaiable-length character type, but has unlimited length.

2. Describe the difference between the integer, decimal, and real data types.

These are all numeric data types.

  * Integer stores only whole (non fractional) numbers such as `1`, `11`, `121`, etc.. It has a range of   `-2147483648` to `+2147483647`

  * Decimal (or `numeric`) is an arbitrary precision number, where the precision of the number is user-defined (i.e. it is defined when the column is defined). It can store up to 131072 digits before the decimal point; up to 16383 digits after the decimal point. It is an *exact* type.

  * Real is floating-point type. Unlike decimal/ numeric it is an inexact type. Inexact means that some values cannot be converted exactly to the internal format and are stored as approximations, so that storing and retrieving a value might show slight discrepancies. They have 6 decimal digits precision (`double precision` has 15 decimal digits precision).

3. What is the largest value that can be stored in an integer column?

The largest value that can be stored in teh integer column is `2147483647`.

4. Describe the difference between the timestamp and date data types.

These are both Date/time types.

  * Timestamp includes both date and time

  * Date includes the date but no time of day

5. Can a time with a time zone be stored in a column of type timestamp?

No, you have to use the `timestamp with time zone` (`timestamptz` is an accepted abbreviation) data type.
