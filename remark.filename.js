/*
 * Filename in code listing
 *
 * Put a filename inside the previous div ("pre"), in the bottom right corner
 *
 * Syntax: ![:filename](<filename>)
 */

remark.macros.filename = function () {
  var filename = this;
  return '<div style="margin-top:-1.2em">' +
    '<span class="right scriptsize">' +
    filename +
    '</span>' +
    '</div>';
};
