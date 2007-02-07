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


package xpath.expression;
import xpath.expression.Expression;
import xpath.context.Context;
import xpath.type.XPathValue;


class FunctionCall extends Expression {
	
	private var name:String;
	
	private var parameters:Array<Expression>;
	
	
	public function new (name:String, parameters:Array<Expression>) {
		super(this);
		
		this.name = name;
		this.parameters = parameters;
	}
	
	public function evaluate (context:Context) :XPathValue {
		var parameterValues:Array<XPathValue> = new Array<XPathValue>();
		for (parameter in parameters) {
			parameterValues.push(parameter.expressionApi.evaluate(context));
		}
		
		return context.callFunction(name, parameterValues);
	}
	
}