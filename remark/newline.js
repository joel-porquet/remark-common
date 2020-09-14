/*
 * Newline macro
 *
 * Syntax: ![:newline num]
 * - Num can be an integer for multiple lines or a fraction of a line
 */
remark.macros.newline = function (n) {
  n = n || 1; /* default value is 1 line */
  return '<div style="'
    + 'height:' + n + 'em; '
    + 'width:100%; '
    + 'margin: 0; '
    + 'padding: 0; '
    + 'border: 0; '
    + 'display: block;'
    + '" ></div>';
};

