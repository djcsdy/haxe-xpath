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


/** Class implementing the union of two environments. */
class UnionEnvironment implements Environment {
	
	private var primary:Environment;
	private var secondary:Environment;
	
	
	/** Constructs a new Environment which is the union of existing primary and secondary
	 * environments. Functions and variables which are defined by the primary environment
	 * override those which are defined by the secondary environment. */
	public function new (primary:Environment, secondary:Environment) {
		this.primary = primary;
		this.secondary = secondary;
	}
	
	/** Tests if a function with the specified name is provided by this environment. */
	public function existsFunction (name:String) :Bool {
		return primary.existsFunction(name) || secondary.existsFunction(name);
	}
	
	/** Returns a reference to the function with the specified name. */
	public function getFunction (name:String) :XPathFunction {
		if (primary.existsFunction(name)) return primary.getFunction(name);
		else return secondary.getFunction(name);
	}
	
	/** Calls a function with the specified parameters and returns the result. */
	public function callFunction (context:Context, name:String, ?parameters:Array<XPathValue>) :XPathValue {
		return getFunction(name)(context, parameters);
	}
	
	/** Tests if a variable with the specified name is provided by this environment. */
	public function existsVariable (name:String) :Bool {
		return primary.existsVariable(name) || secondary.existsVariable(name);
	}
	
	/** Gets the value of the variable with the specified name. */
	public function getVariable (name:String) :XPathValue {
		if (primary.existsVariable(name)) return primary.getVariable(name);
		else return secondary.getVariable(name);
	}

}