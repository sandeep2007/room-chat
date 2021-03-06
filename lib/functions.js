let obj = {};

const dbPrefix = process.env.DATABASE_PREFIX;

obj.isEmpty = (value) => {
    var isEmptyObject = function (a) {
        if (typeof a.length === 'undefined') { // it's an Object, not an Array
            var hasNonempty = Object.keys(a).some(function nonEmpty(element) {
                return !obj.isEmpty(a[element]);
            });
            return hasNonempty ? false : isEmptyObject(Object.keys(a));
        }

        return !a.some(function nonEmpty(element) { // check if array is really not empty as JS thinks
            return !obj.isEmpty(element); // at least one element should be non-empty
        });
    };
    return (
        value == false
        || typeof value === 'undefined'
        || value == null
        || (typeof value === 'object' && isEmptyObject(value))
    );
}

obj.getTableName = (table) => {
    return dbPrefix + table;
}

module.exports = obj;