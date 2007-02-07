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
import xpath.XPathInternalException;
import xpath.context.Context;
import xpath.token.OperatorToken;
import xpath.type.XPathValue;


class Operation extends Expression {
	
	private var leftOperand:Expression;
	private var operator:OperatorEnum;
	private var rightOperand:Expression;
	
	
	public function new (leftOperand:Expression, operator:OperatorEnum, rightOperand:Expression) {
		super(this);
		
		this.leftOperand = leftOperand;
		this.operator = operator;
		this.rightOperand = rightOperand;
	}
	
	public function evaluate (context:Context) :XPathValue {
		var leftValue:XPathValue = leftOperand.expressionApi.evaluate(context);

		if (operator == And) {
			if (!leftValue.xPathValueApi.getBool()) return leftValue;
			else return rightOperand.expressionApi.evaluate(context);
		} else if (operator == Or) {
			if (leftValue.xPathValueApi.getBool()) return leftValue;
			else return rightOperand.expressionApi.evaluate(context);
		} else {
			var rightValue:XPathValue = rightOperand.expressionApi.evaluate(context);
			
			if (operator == Equal) {
				return leftValue.xPathValueApi.equals(rightValue);
			} else if (operator == NotEqual) {
				return leftValue.xPathValueApi.notEqual(rightValue);
			} else if (operator == LessThanOrEqual) {
				return leftValue.xPathValueApi.lessThanOrEqual(rightValue);
			} else if (operator == GreaterThanOrEqual) {
				return leftValue.xPathValueApi.greaterThanOrEqual(rightValue);
			} else if (operator == LessThan) {
				return leftValue.xPathValueApi.lessThan(rightValue);
			} else if (operator == GreaterThan) {
				return leftValue.xPathValueApi.greaterThan(rightValue);
			} else if (operator == Plus) {
				return leftValue.plus(rightValue);
			} else if (operator == Minus) {
				return leftValue.minus(rightValue);
			} else if (operator == Multiply) {
				return leftValue.multiply(rightValue);
			} else if (operator == Divide) {
				return leftValue.divide(rightValue);
			} else if (operator == Modulo) {
				return leftValue.modulo(rightValue);
			} else if (operator == Union) {
				return leftValue.union(rightValue);
			} else {
				throw new XPathInternalException();
			}
		}
	}
	
}