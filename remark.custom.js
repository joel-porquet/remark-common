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

/*
 * Filename in code listing
 *
 * Put a filename inside the previous div ("pre"), in the bottom right corner
 *
 * Syntax: ![:filename](<filename>)
 */
remark.macros.filename = function () {
  var filename = this;
  return '<div style="margin-top:-1.1em">' +
    '<span class="right tiny">' +
    filename +
    '</span>' +
    '</div>';
};

/*
 * Image scaling macro
 *
 * Syntax: ![:scale 50%](image.jpg)
 * https://github.com/gnab/remark/issues/72
 */
remark.macros.scale = function (percentage, align) {
	align = align || "center"; /* Default is center */
  var url = this;
  return '<div class="' + align + '"><img src="'
    + url + '" style="width: ' + percentage + '" /></div>';
};
