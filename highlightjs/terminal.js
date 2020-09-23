/*
 * Language: Terminal console
 * Author: Joël Porquet <joel@porquet.org>
 * Based on file written by Josh Bode <joshbode@gmail.com>
 */
var hljs = remark.highlighter.engine;
hljs.registerLanguage('terminal',
  function() {
    return {
      contains: [
        {
          className: 'section',
          begin: /^[\w]*[$#] /,
          starts: {
            end: /$/, subLanguage: 'bash',
            relevance: 1,
          }
        },
      ]
    }
  }
);

