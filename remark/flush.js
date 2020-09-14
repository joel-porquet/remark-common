/*
 * Flush macro to terminate a multi-column environment (combined with skipping
 * some lines, none by default)
 *
 * Syntax: ![:flush num]
 * - Num can be an integer for multiple lines or a fraction of a line
 */
remark.macros.flush = function (n) {
  n = n || 0; /* default value is 0 line */
  return '<div style="'
    + 'height:' + n + 'em; '
    + 'width:100%; '
    + 'margin: 0; '
    + 'padding: 0; '
    + 'border: 0; '
    + 'clear: both; '
    + 'display: block;'
    + '" ></div>';
};
