/*
 * Language: GDB prompt
 * Author: Joël Porquet <joel@porquet.org>
 */
var hljs = remark.highlighter.engine;
hljs.registerLanguage('gdb',
  function() {
    return {
      contains: [
        hljs.HASH_COMMENT_MODE,
        {
          className: 'section',
          begin: /^\(gdb\)/,
        },
      ]
    }
  }
);

