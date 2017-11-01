/*
 * Image scaling macro
 *
 * Syntax: ![:scale 50%](image.jpg)
 * https://github.com/gnab/remark/issues/72
 */

remark.macros.scale = function (percentage) {
  var url = this;
  return '<div class="center"><img src="'
    + url + '" style="width: ' + percentage + '" /></div>';
};
