/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS AND ANY EXPRESS 
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


/** Class implementing boolean functions from the XPath core function library. For more
 * information about the implementation of functions in XPath, see
 * xpath.type.XPathFunction. */
class BooleanLibrary {
	
	/** boolean() function from the XPath core function library. The query must pass
	 * exactly one parameter which is converted to a boolean by calling getXPathBoolean.
	 * Throws XPathEvaluationException if parameters.length != 1. */
	public static function boolean (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 1) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		return parameters[0].getXPathBoolean();
	}
	
	/** not() function from the XPath core function library. The query must pass exactly
	 * one parameter which is converted to a boolean by calling getXPathBoolean. The
	 * sense of the boolean is then inverted and the result returned.
	 * Throws XPathEvaluationException if parameters.length != 1. */
	public static function not (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 1) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		return new XPathBoolean(!parameters[0].xPathValueApi.getBool());
	}
	
	/** true() function from the XPath core function library. The query must pass no
	 * parameters. Throws XPathEvaluationException if parameters.length != 0. */
	public static function true (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 0) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		return new XPathBoolean(true);
	}
	
	/** false() function from the XPath core function library. The query must pass no
	 * parameters. Throws XPathEvaluationException if parameters.length != 0. */
	public static function false (context:Context, parameters:Array<XPathValue>) :XPathValue {
		if (parameters.length != 0) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		return new XPathBoolean(false);
	}
	
}