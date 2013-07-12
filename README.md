
Haxe XPath aims to be a complete implementation of XPath for Haxe.
To get started, See the documentation for the class `xpath.XPath`.

Haxe XPath is presently very much in an alpha state and so the
following caveats must be considered:

 * This version has “potential” support for any XML class.
   Support can be provided by providing a wrapper for the desired
   XML class that extends `xpath.xml.XPathXml`. At present, a wrapper
   for the Haxe Xml class is provided in `xpath.xml.XPathHxXml`.
 * The XPath functions `id()`, `namespace-uri()` and `lang()` are not
   implemented.
 * XPath treats XML comments as nodes, but neither Haxe’s built in
   XML class nor dcxml support this yet. Therefore, XPath features
   relating to comments are not working. Similarly, positional
   predicates, or use of the `position()` function that assumes the
   presence of comments will break, although XPath queries written
   in such a way are already badly broken.
 * Lots of unit tests are missing. Patches welcome.
 * XML namespaces are not supported, yet. The `name()` function
   therefore behaves as `local-name()`.

Please direct comments, questions, patches and bug reports to
https://github.com/djcsdy/haxe-xpath/issues/new
