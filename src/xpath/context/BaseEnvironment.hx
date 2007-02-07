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


package xpath.context;
import xpath.context.Environment;
import xpath.context.Context;
import xpath.type.XPathFunction;
import xpath.type.XPathValue;
import xpath.context.CoreEnvironment;


/** Base implementation of Environment which may be extended by users.
 *
 * An environment provides a set of named variables and functions which may
 * be referenced from an XPath query. Variables should be of the type
 * [xpath.type.XPathValue] (or a derivative type).
 * Functions must match the signature defined by
 * [xpath.type.XPathFunction].
 *
 * This class provides two private variables,
 * [functions:Hash&lt;XPathFunction&gt;] and
 * [variables:Hash&lt;XPathValue&gt;], which hash functions and
 * variables by name. To add or remove functions or variables, simply add
 * them to or remove them from the corresponding Hash (for example, in the
 * constructor).
 *
 * For an example of an Environment implemented by extending BaseEnvironment,
 * see the source code for [CoreEnvironment]. */
class BaseEnvironment implements Environment {
	
	private var functions:Hash<XPathFunction>;
	private var variables:Hash<XPathValue>;
	
	
	private function new () {
		functions = new Hash<XPathFunction>();
		variables = new Hash<XPathValue>();
	}
	
	/** Tests if a function with the specified name is provided by this environment. */
	public function existsFunction (name:String) :Bool {
		return functions.exists(name);
	}
	
	/** Returns a reference to the function with the specified name. */
	public function getFunction (name:String) :XPathFunction {
		return functions.get(name);
	}
	
	/** Calls a function with the specified parameters and returns the result. */
	public function callFunction (context:Context, name:String, ?parameters:Array<XPathValue>) :XPathValue {
		return getFunction(name)(context, parameters);
	}
	
	/** Tests if a variable with the specified name is provided by this environment. */
	public function existsVariable (name:String) :Bool {
		return variables.exists(name);
	}
	
	/** Gets the value of the variable with the specified name. */
	public function getVariable (name:String) :XPathValue {
		return variables.get(name);
	}

}