haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
Dedicated to the Public Domain

=====================================================================

DISCLAIMER

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=====================================================================


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

The following issues should also be considered carefully:
 * Lots of Flash coders are accustomed to using the xfactorstudio
   implementation of XPath. However, that implementation is
   incomplete and inconsistent with the XPath spec in many ways.
   In particular, the xfactorstudio implementation's treatment
   of queries beginning "//" is incorrect, but widely relied upon.

Comments, questions and patches are all very welcome by personal
mail to mail@danielcassidy.me.uk.
