/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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
import xpath.context.Context;
import xpath.Operator;
import xpath.XPathError;


class Operation implements Expression {
	
	var leftOperand :Expression;
	var operator :Operator;
	var rightOperand :Expression;
	
	
	public function new (
		leftOperand:Expression, operator:Operator,
		rightOperand:Expression
	) {
		this.leftOperand = leftOperand;
		this.operator = operator;
		this.rightOperand = rightOperand;
	}
	
	public function evaluate (context:Context) {
		var leftValue = leftOperand.evaluate(context);
		
		if (operator == Operator.And) {
			if (!leftValue.getBool()) return leftValue;
			else return rightOperand.evaluate(context);
		} else if (operator == Operator.Or) {
			if (leftValue.getBool()) return leftValue;
			else return rightOperand.evaluate(context);
		} else {
			var rightValue = rightOperand.evaluate(context);
			
			if (operator == Operator.Equal) {
				return leftValue.equals(rightValue);
			} else if (operator == Operator.NotEqual) {
				return leftValue.notEqual(rightValue);
			} else if (operator == Operator.LessThanOrEqual) {
				return leftValue.lessThanOrEqual(rightValue);
			} else if (operator == Operator.GreaterThanOrEqual) {
				return leftValue.greaterThanOrEqual(rightValue);
			} else if (operator == Operator.LessThan) {
				return leftValue.lessThan(rightValue);
			} else if (operator == Operator.GreaterThan) {
				return leftValue.greaterThan(rightValue);
			} else if (operator == Operator.Plus) {
				return leftValue.plus(rightValue);
			} else if (operator == Operator.Minus) {
				return leftValue.minus(rightValue);
			} else if (operator == Operator.Multiply) {
				return leftValue.multiply(rightValue);
			} else if (operator == Operator.Divide) {
				return leftValue.divide(rightValue);
			} else if (operator == Operator.Modulo) {
				return leftValue.modulo(rightValue);
			} else if (operator == Operator.Union) {
				return leftValue.union(rightValue);
			} else {
				throw new XPathError();
			}
		}
	}
	
}
