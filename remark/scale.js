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
