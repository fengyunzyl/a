/* This is a script to format Wikipedia links.
 * On Firefox you click
 * Tools > Web Developer > Scratchpad
 *
 * It will turn the current URL from this
 * http://en.wikipedia.org/w/index.php?title=Comparison_of_file_hosting_services&diff=468309024&oldid=468304586
 *
 * To this
 * {{diff|Comparison_of_file_hosting_services|468309024|468304586}}
 *
 * Thanks to
 * wikipedia.org/wiki/Template:Diff
 * stackoverflow.com/questions/400212
 * developer.mozilla.org/en/JavaScript/Guide/Regular_Expressions
 */

var re = /.+title=(.+)&diff=(.+)&oldid=(.+)/;
var str = location.href;
var newstr = str.replace(re, '{{diff|$1|$2|$3}}');
window.prompt(str, newstr);
