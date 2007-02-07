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


package xpath;
import dcxml.Xml;
import xpath.XPathParseException;
import xpath.XPathInternalException;
import xpath.XPathEvaluationException;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.tokenizer.container.XPathTokenizer;
import xpath.parser.Parser;
import xpath.parser.ParseState;
import xpath.parser.XPathParser;
import xpath.expression.Expression;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.CoreEnvironment;
import xpath.context.UnionEnvironment;
import xpath.type.XPathValue;
import xpath.type.XPathNodeSet;


/** Class implementing an XPath query.
 *
 * In this implementation, the compilation and evaluation of XPath queries
 * are seperated into two steps. In this way, if a single XPath
 * query is to be evaluated more than once, only a single compilation is
 * required.
 *
 * To compile an XPath query, call the XPath constructor with the query
 * string as its argument:[
 * var xpathStr = new XPath("/a/b/c");]
 *
 * The resulting object may now be used to evaluate the query relative to
 * a given context node:[
 * var result = xpath.evaluate(xml);]
 *
 * Convenience functions are also provided to obtain the result of the
 * query in a variety of forms:[
 * xpath.selectNode(xml); // returns zero or one Xml nodes
 * xpath.selectNodes(xml); // returns zero or more Xml nodes
 * xpath.evaluateAsString(xml); // returns a String
 * xpath.evaluateAsFloat(xml); // returns a Float
 * xpath.evaluateAsBool(xml); // returns a Bool]
 *
 * All XPath queries execute in the context of an Environment, which provides
 * a set of variables and functions that may be referenced from the query.
 * The default environment, CoreEnvironment provides those functions defined
 * by the XPath core function library, but no variables.
 *
 * Environment variables can be used to avoid the need for dynamically
 * generated queries and the resulting need for repeated compilation. For
 * example, the queries [a/b/c], [a/b/d] and [a/b/e]
 * can be replaced by the single query [a/b/[name()=$n]]. This
 * single query can then be compiled once, and executed three times in an
 * environment with the variable [n] set to ["c"], ["d"]
 * and ["e"] respectively.
 *
 * An environment may be provided to an XPath query both at compile time
 * (by passing the environment as an argument to the XPath constructor) and
 * at evaluation time (by passing the environment as an argument to
 * [evaluate], [selectNodes], etc). The variables and functions
 * provided by the CoreEnvironment are always available, unless they are
 * overridden. If an environment is provided at compile time, then the
 * variables and functions provided override those provided by the
 * CoreEnvironment. If an environment is provided at evaluation time, then the
 * variables and functions provided override those provided both by the
 * CoreEnvironment and by the environment provided at compile time.
 *
 * Users wishing to provide their own custom environments should see the
 * documentation for [xpath.context.DynamicEnvironment] and
 * [xpath.context.BaseEnvironment]. */
class XPath {
	
	private var expression:Expression;
	
	private var environment:Environment;
	
	
	/** Compiles an XPath query string into a parse tree, which may then be used to efficiently
	 * execute the query. Throws XPathParseException if the query string cannot be parsed. */
	public function new (xpathStr:String, ?environment:Environment) {
		if (environment == null) this.environment = CoreEnvironment.getInstance();
		else this.environment = new UnionEnvironment(environment, CoreEnvironment.getInstance());
		
		var tokenizeState:TokenizeState = new TokenizeState(xpathStr);
		tokenizeState = XPathTokenizer.getInstance().tokenize(tokenizeState);
		
		if (tokenizeState.result == null) {
			throw new XPathParseException("Unknown syntax error");
		}
		
		var parseState:ParseState = new ParseState(tokenizeState.result);
		tokenizeState = null;
		parseState = XPathParser.getInstance().parse(parseState);

		try {
			this.expression = cast(parseState.result, Expression);
		} catch (e:String) {
			throw new XPathInternalException();
		}
	}
	
	/** Evaluates the XPath query. Throws XPathEvaluationException if evaluation
	 * of the query fails. */
	public function evaluate (contextNode:Xml, ?environment:Environment) :XPathValue {
		if (environment == null) environment = this.environment;
		else environment = new UnionEnvironment(environment, this.environment);
		return expression.expressionApi.evaluate(new Context(contextNode, 1, 1, environment));
	}
	
	/** Evaluates the XPath query, returning the result as an array of Xml nodes.
	 * Throws XPathEvaluationException if the query does not evaluate to a node set.
	 * Throws XPathEvaluationException if evaluation of the query fails. */
	public function selectNodes (contextNode:Xml, ?environment:Environment) :Array<Xml> {
		var result:XPathValue = evaluate(contextNode, environment);
		if (Std.is(result, XPathNodeSet)) {
			return cast(result, XPathNodeSet).getNodes();
		} else {
			throw new XPathEvaluationException(
				"Query evaluated to a " + result.typeName + ", but a node set was expected"
			);
			return null;
		}
	}
	
	/** Evaluates the XPath query, returning the result as a single XML node.
	 * Throws XPathEvaluationException if evaluation of the query fails.
	 * Throws XPathEvaluationException if the result of the query is not a node set. */
	public function selectNode (contextNode:Xml, ?environment:Environment) :Xml {
		var result:XPathValue = evaluate(contextNode, environment);
		if (Std.is(result, XPathNodeSet)) {
			return cast(result, XPathNodeSet).getNodes()[0];
		} else {
			throw new XPathEvaluationException(
				"Expression evaluated to a " + result.typeName + ", but a node set was expected"
			);
			return null;
		}
	}
	
	/** Alias for selectNode. */
	public function selectSingleNode (contextNode:Xml, ?environment:Environment) :Xml {
		return selectNode(contextNode, environment);
	}
	
	/** Evaluates the XPath query, returning the result as a string.
	 * Throws XPathEvaluationException if evaluation of the query fails. */
	public function evaluateAsString (contextNode:Xml, ?environment:Environment) :String {
		return evaluate(contextNode, environment).xPathValueApi.getString();
	}
	
	/** Evaluates the XPath query, returning the result as a float.
	 * Throws XPathEvaluationException if evaluation of the query fails. */
	public function evaluateAsFloat (contextNode:Xml, ?environment:Environment) :Float {
		return evaluate(contextNode, environment).xPathValueApi.getFloat();
	}

	/** Evaluates the XPath query, returning the result as a bool.
	 * Throws XPathEvaluationException if evaluation of the query fails. */
	public function evaluateAsBool (contextNode:Xml, ?environment:Environment) :Bool {
		return evaluate(contextNode, environment).xPathValueApi.getBool();
	}
	
}
