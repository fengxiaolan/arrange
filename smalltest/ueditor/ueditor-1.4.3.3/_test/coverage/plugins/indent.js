/* automatically generated by JSCoverage - do not edit */
try {
  if (typeof top === 'object' && top !== null && typeof top.opener === 'object' && top.opener !== null) {
    // this is a browser window that was opened from another window

    if (! top.opener._$jscoverage) {
      top.opener._$jscoverage = {};
    }
  }
}
catch (e) {}

try {
  if (typeof top === 'object' && top !== null) {
    // this is a browser window

    try {
      if (typeof top.opener === 'object' && top.opener !== null && top.opener._$jscoverage) {
        top._$jscoverage = top.opener._$jscoverage;
      }
    }
    catch (e) {}

    if (! top._$jscoverage) {
      top._$jscoverage = {};
    }
  }
}
catch (e) {}

try {
  if (typeof top === 'object' && top !== null && top._$jscoverage) {
    _$jscoverage = top._$jscoverage;
  }
}
catch (e) {}
if (typeof _$jscoverage !== 'object') {
  _$jscoverage = {};
}
if (! _$jscoverage['plugins/indent.js']) {
  _$jscoverage['plugins/indent.js'] = [];
  _$jscoverage['plugins/indent.js'][30] = 0;
  _$jscoverage['plugins/indent.js'][32] = 0;
  _$jscoverage['plugins/indent.js'][33] = 0;
  _$jscoverage['plugins/indent.js'][36] = 0;
  _$jscoverage['plugins/indent.js'][37] = 0;
}
_$jscoverage['plugins/indent.js'].source = ["<span class=\"c\">/**</span>","<span class=\"c\"> * &#32553;&#36827;</span>","<span class=\"c\"> * @file</span>","<span class=\"c\"> * @since 1.2.6.1</span>","<span class=\"c\"> */</span>","","<span class=\"c\">/**</span>","<span class=\"c\"> * &#32473;&#36873;&#21306;&#20869;&#25991;&#26412;&#28155;&#21152;&#32553;&#36827;</span>","<span class=\"c\"> * @command indent</span>","<span class=\"c\"> * @method execCommand</span>","<span class=\"c\"> * @param { String } cmd &#21629;&#20196;&#23383;&#31526;&#20018;</span>","<span class=\"c\"> * @example</span>","<span class=\"c\"> * ```javascript</span>","<span class=\"c\"> * editor.execCommand( 'indent' );</span>","<span class=\"c\"> * ```</span>","<span class=\"c\"> */</span>","","<span class=\"c\">/**</span>","<span class=\"c\"> * &#36820;&#22238;&#24403;&#21069;&#36873;&#21306;&#20301;&#32622;&#26159;&#21542;&#26377;&#32553;&#36827;</span>","<span class=\"c\"> * @command indent</span>","<span class=\"c\"> * @method queryCommandState</span>","<span class=\"c\"> * @param { String } cmd &#21629;&#20196;&#23383;&#31526;&#20018;</span>","<span class=\"c\"> * @return { int } 0&#20026;&#19981;&#26159;&#65292;1&#20026;&#26159;</span>","<span class=\"c\"> * @example</span>","<span class=\"c\"> * ```javascript</span>","<span class=\"c\"> * editor.queryCommandState( 'indent' );</span>","<span class=\"c\"> * ```</span>","<span class=\"c\"> */</span>","","UE<span class=\"k\">.</span>commands<span class=\"k\">[</span><span class=\"s\">'indent'</span><span class=\"k\">]</span> <span class=\"k\">=</span> <span class=\"k\">{</span>","    execCommand <span class=\"k\">:</span> <span class=\"k\">function</span><span class=\"k\">()</span> <span class=\"k\">{</span>","         <span class=\"k\">var</span> me <span class=\"k\">=</span> <span class=\"k\">this</span><span class=\"k\">,</span>value <span class=\"k\">=</span> me<span class=\"k\">.</span>queryCommandState<span class=\"k\">(</span><span class=\"s\">\"indent\"</span><span class=\"k\">)</span> <span class=\"k\">?</span> <span class=\"s\">\"0em\"</span> <span class=\"k\">:</span> <span class=\"k\">(</span>me<span class=\"k\">.</span>options<span class=\"k\">.</span>indentValue <span class=\"k\">||</span> <span class=\"s\">'2em'</span><span class=\"k\">);</span>","         me<span class=\"k\">.</span>execCommand<span class=\"k\">(</span><span class=\"s\">'Paragraph'</span><span class=\"k\">,</span><span class=\"s\">'p'</span><span class=\"k\">,</span><span class=\"k\">{</span>style<span class=\"k\">:</span><span class=\"s\">'text-indent:'</span><span class=\"k\">+</span> value<span class=\"k\">}</span><span class=\"k\">);</span>","    <span class=\"k\">}</span><span class=\"k\">,</span>","    queryCommandState <span class=\"k\">:</span> <span class=\"k\">function</span><span class=\"k\">()</span> <span class=\"k\">{</span>","        <span class=\"k\">var</span> pN <span class=\"k\">=</span> domUtils<span class=\"k\">.</span>filterNodeList<span class=\"k\">(</span><span class=\"k\">this</span><span class=\"k\">.</span>selection<span class=\"k\">.</span>getStartElementPath<span class=\"k\">(),</span><span class=\"s\">'p h1 h2 h3 h4 h5 h6'</span><span class=\"k\">);</span>","        <span class=\"k\">return</span> pN <span class=\"k\">&amp;&amp;</span> pN<span class=\"k\">.</span>style<span class=\"k\">.</span>textIndent <span class=\"k\">&amp;&amp;</span> parseInt<span class=\"k\">(</span>pN<span class=\"k\">.</span>style<span class=\"k\">.</span>textIndent<span class=\"k\">)</span> <span class=\"k\">?</span>  <span class=\"s\">1</span> <span class=\"k\">:</span> <span class=\"s\">0</span><span class=\"k\">;</span>","    <span class=\"k\">}</span>","","<span class=\"k\">}</span><span class=\"k\">;</span>"];
_$jscoverage['plugins/indent.js'][30]++;
UE.commands.indent = {execCommand: (function () {
  _$jscoverage['plugins/indent.js'][32]++;
  var me = this, value = (me.queryCommandState("indent")? "0em": (me.options.indentValue || "2em"));
  _$jscoverage['plugins/indent.js'][33]++;
  me.execCommand("Paragraph", "p", {style: ("text-indent:" + value)});
}), queryCommandState: (function () {
  _$jscoverage['plugins/indent.js'][36]++;
  var pN = domUtils.filterNodeList(this.selection.getStartElementPath(), "p h1 h2 h3 h4 h5 h6");
  _$jscoverage['plugins/indent.js'][37]++;
  return ((pN && pN.style.textIndent && parseInt(pN.style.textIndent))? 1: 0);
})};