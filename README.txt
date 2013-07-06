
haXe XPath aims to be a complete implementation of XPath for haXe.
To get started, See the documentation for the class xpath.XPath.

haXe XPath is presently very much in an alpha state and so the
following caveats must be considered:
 * This version has "potential" support for any XML class.
   Support can be provided by providing a wrapper for the desired
   XML class that extends xpath.xml.XPathXml. At present, a wrapper
   for the haXe Xml class is provided in xpath.xml.XPathHxXml.
 * The previous version directly supported dcxml. At present there
   is no support for dcxml in this version. You can still install
   the old version using haxelib.
 * haXe XPath doesn't compile for JavaScript at the moment. This
   will be fixed in the future, although patches are always
   welcome.
 * The XPath functions id(), namespace-uri() and lang() are not
   implemented.
 * XPath treats XML comments as nodes, but neither haXe's built in
   XML class nor dcxml support this yet. Therefore, XPath features
   relating to comments are not working. Similarly, positional
   predicates, or use of the position() function that assumes the
   presence of comments will break, although XPath queries written
   in such a way are already badly broken.
 * Lots of unit tests are missing. Patches welcome.
 * XML namespaces are not supported, yet. The name() function
   therefore behaves as local-name().

Comments, questions and patches are all very welcome by personal
mail to mail@danielcassidy.me.uk.
