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


/** Class implementing node set functions from the XPath core function library. For more
 * information about the implementation of functions in XPath, see
 * xpath.type.XPathFunction. */
class NodeSetLibrary {
	
	/** last() function from the XPath core function library. The query must pass no
	 * parameters. Throws XPathEvaluationException if parameters.length != 0. */
	public static function last (context:Context, parameters:Array<XPathValue>) :XPathNumber {
		if (parameters.length > 0) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		return new XPathNumber(context.size);
	}
	
	/** position() function from the XPath core function library. The query must pass no
	 * parameters. Throws XPathEvaluationException if parameters.length != 0. */
	public static function position (context:Context, parameters:Array<XPathValue>) :XPathNumber {
		if (parameters.length > 0) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		return new XPathNumber(context.position);
	}
	
	/** count() function from the XPath core function library. The query must pass
	 * exactly one parameter, which should be a node set. Throws
	 * XPathEvaluationException if parameters.length != 1, or if the parameter
	 * is not a node set. */
	public static function count (context:Context, parameters:Array<XPathValue>) :XPathNumber {
		if (parameters.length != 1) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		if (!Std.is(parameters[0], XPathNodeSet)) {
			throw new XPathEvaluationException(
				"Parameter was a " + parameters[0].typeName + ", but a node set was expected"
			);
		}
		var nodeSet:XPathNodeSet = cast(parameters[0], XPathNodeSet);
		var count:Int = nodeSet.getNodes().length;
		return new XPathNumber(count);
	}
	
	/** local-name() function from the XPath core function library. The query must pass
	 * one or no parameters. If a parameter is passed, it must be a node set. If no
	 * parameter is passed, the function executes as if a node set with the context
	 * node as its only member were passed as a parameter. Throws XPathEvaluationException
	 * if parameters.length > 1, or if the parameter is not a node set. */
	public static function localName (context:Context, parameters:Array<XPathValue>) :XPathNumber {
		if (parameters.length > 1) {
			throw new XPathEvaluationException("Incorrect parameter count");
		}
		
		var node:Xml;
		if (parameters[0] == null) {
			node = context.node;
		} else {
			if (!Std.is(parameters[0], XPathNodeSet)) {
				throw new XPathEvaluationException(
					"Parameter was a " + parameters[0].typeName + ", but a node set was expected"
				);
			}
			node = cast(parameters[0], XPathNodeSet).getFirstNodeDocumentOrder();
		}
		
		return new XPathString(node.name);
	}
	
	/** name() function from the XPath core function library. Currently this function
	 * is not fully implemented and behaves exactly as local-name(). Throws
	 * XPathEvaluationException if parameters.length != 1, or if the parameter
	 * is not a node set. */
	public static function name (context:Context, parameters:Array<XPathValue>) :XPathNumber {
		// FIXME
		return localName(context, parameters);
	}

}