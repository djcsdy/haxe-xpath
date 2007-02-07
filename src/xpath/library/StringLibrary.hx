/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.library;
import dcxml.Xml;
import xpath.XPathEvaluationException;
import xpath.context.Environment;
import xpath.context.Context;
import xpath.type.XPathValue;
import xpath.type.XPathBoolean;
import xpath.type.XPathNumber;
import xpath.type.XPathString;
import xpath.type.XPathNodeSet;


/** Class implementing string functions from the XPath core function library. For more
 * information about the implementation of functions in XPath, see
 * xpath.type.XPathFunction. */
class StringLibrary {
	
	/** number() function from the XPath core function library. The query must pass either
	 * one parameter or no parameters. If no parameter is passed, then the function behaves
	 * as if an XPathNodeSet containing only the context node were passed as a parameter.
	 * The parameter is then converted to an XPathString by calling getXPathString.
     * Throws XPathEvaluationException if parameters.length > 1. */
	public static function string (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length > 1) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		if (parameters[0] == null) return new XPathString(context.node.getStringValue());
		else return parameters[0].getXPathString();
	}
	
	/** concat() function from the XPath core function library. The query must pass two or
	 * more parameters, which are converted into XPathStrings by calling getXPathString, and
	 * then concatenated into a single XPathString. Throws XPathEvaluationException if
	 * parameters.length < 2. */
	public static function concat (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length < 2) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var buf:StringBuf = new StringBuf();
		for (parameter in parameters) {
			buf.add(parameter.xPathValueApi.getString());
		}
		return new XPathString(buf.toString());
	}
	
	/** starts-with() function from the XPath core function library. The query must pass
	 * exactly two parameters, which are converted into XPathStrings by calling
	 * getXPathString. Determines if the first string begins with the second string.
	 * Throws XPathEvaluationException if parameters.length != 2. */
	public static function startsWith (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 2) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String = parameters[0].xPathValueApi.getString();
		var substring:String = parameters[1].xPathValueApi.getString();
		return new XPathBoolean(string.substr(0, substring.length) == substring);
	}
	
	/** contains() function from the XPath core function library. The query must pass
	 * exactly two parameters, which are converted into XPathStrings by calling
	 * getXPathString. Determines if the first string contains the second string.
	 * Throws XPathEvaluationException if parameters.length != 2. */
	public static function contains (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 2) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String = parameters[0].xPathValueApi.getString();
		var substring:String = parameters[1].xPathValueApi.getString();
		return new XPathBoolean (string.indexOf(substring) >= 0);
	}
	
	/** substring-before() function from the XPath core function library. The query
	 * must pass exactly two parameters, which are converted into XPathStrings by calling
	 * getXPathString.
	 * Throws XPathEvaluationException if parameters.length != 2. */
	public static function substringBefore (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 2) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String = parameters[0].xPathValueApi.getString();
		var substring:String = parameters[1].xPathValueApi.getString();
		var i:Int = string.indexOf(substring);
		return new XPathString(string.substr(0, i));
	}
	
	/** substring-after() function from the XPath core function library. The query must
	 * pass exactly two parameters, which are converted into XPathStrings by calling
	 * getXPathString.
	 * Throws XPathEvaluationException if parameters.length != 2. */
	public static function substringAfter (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 2) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String = parameters[0].xPathValueApi.getString();
		var substring:String = parameters[1].xPathValueApi.getString();
		var i:Int = string.indexOf(substring) + substring.length;
		return new XPathString(string.substr(0, i));
	}
	
	/** substring() function from the XPath core function library. The query must pass
	 * either two or three parameters. The first parameter is converted to an XPathString
	 * by calling getXPathString. The second and optional third parameters are converted
	 * to XPathNumbers by calling getXPathNumber.
	 * Throws XPathEvaluationException unless two or three parameters are passed. */
	public static function substring (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length < 2 || parameters.length > 3) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String = parameters[0].xPathValueApi.getString();
		var start:Int = Std.int(parameters[1].xPathValueApi.getFloat()) - 1;
		var length:Int;
		if (parameters[2] == null) length = null;
		else length = Std.int(parameters[2].xPathValueApi.getFloat());
		return new XPathString(string.substr(start, length));
	}
	
	/** string-length() function from the XPath core function library. The query must pass
	 * either no parameters or one parameter. If no parameters are passed, then the function
	 * behaves as if an XPathNodeSet containing only the context node were passed.
	 * The parameter is converted to an XPathString by calling getXPathString, and the
	 * number of characters in the resulting string determined.
	 * Throws XPathEvaluationException if parameters.length > 1. */
	public static function stringLength (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length > 1) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String = parameters[0].xPathValueApi.getString();
		return new XPathNumber(string.length);
	}
	
	/** normalize-space() function from the XPath core function library. The query must pass
	 * either no parameters or one parameter. If no parameters are passed, then the function
	 * behaves as if an XPathNodeSet containing only the context node were passed. The
	 * parameter is converted to an XPathString by calling getXPathString. The resulting
	 * string is then whitespace-normalized by stripping leading and trailing whitespace and
	 * replacing sequences of whitespace characters with a single space.
	 * Throws XPathEvaluationException if parameters.length > 1. */
	public static function normalizeSpace (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length > 1) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String;
		if (parameters[0] == null) string = context.node.getStringValue();
		else string = parameters[0].xPathValueApi.getString();
		
		var buf:StringBuf = new StringBuf();
		var doneSpace:Bool = true;
		for (i in 0...string.length) {
			var c:String = string.charAt(i);
			if (c == " " || c == "\t" || c == "\n" || c == "\r") {
				if (!doneSpace) {
					buf.add(" ");
					doneSpace = true;
				}
			} else {
				doneSpace = false;
				buf.add(c);
			}
		}
		
		return new XPathString(StringTools.rtrim(buf.toString()));
	}
	
	/** translate() function from the XPath core function library. The query must pass
	 * exactly three parameters which are converted to XPathStrings by calling
	 * getXPathString. Constructs a new XPathString which is a copy of the first
	 * parameter, but with characters that appear in the second parameter replaced
	 * by those which appear in the corresponding position in the third parameter.
	 * Characters which appear in the second parameter but for which there is no
	 * corresponding replacement are removed.
	 * Throws XPathEvaluationException if parameters.length != 3. */
	public static function translate (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 3) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		var string:String = parameters[0].xPathValueApi.getString();
		var fromChars:String = parameters[1].xPathValueApi.getString();
		var toChars:String = parameters[2].xPathValueApi.getString();
		
		var translations:Hash<String> = new Hash<String>();
		var i:Int = fromChars.length;
		while (i > 0) {
			--i;
			translations.set(fromChars.charAt(i), toChars.charAt(i));
		}
		
		var buf:StringBuf = new StringBuf();
		for (i in 0...string.length) {
			var c:String = string.charAt(i);
			if (translations.exists(c)) {
				buf.add(translations.get(c));
			} else {
				buf.add(c);
			}
		}
		
		return new XPathString(buf.toString());
	}
		
}