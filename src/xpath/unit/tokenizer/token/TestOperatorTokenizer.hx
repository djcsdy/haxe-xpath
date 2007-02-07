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


package xpath.unit.tokenizer.token;
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.tokenizer.token.OperatorTokenizer;
import xpath.token.OperatorToken;


class TestOperatorTokenizer extends TestCase {
	
	private var operators:Hash<OperatorEnum>;
	
	
	public function new () {
		super();
		operators = new Hash<OperatorEnum>();
		operators.set("and", And);
		operators.set("mod", Modulo);
		operators.set("div", Divide);
		operators.set("or", Or);
		operators.set("!=", NotEqual);
		operators.set("<=", LessThanOrEqual);
		operators.set(">=", GreaterThanOrEqual);
		operators.set("=", Equal);
		operators.set("|", Union);
		operators.set("+", Plus);
		operators.set("-", Minus);
		operators.set("<", LessThan);
		operators.set(">", GreaterThan);
		operators.set("*", Multiply);
	}

	private function testGood () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["", "fmnvisfjg-", "cx. ]", "?MVCZ"]) {
				for (operator in operators.keys()) {
					var state:TokenizeState = new TokenizeState(operator + whitespace + garbage);
					state = OperatorTokenizer.getInstance().tokenize(state);
					
					assertEquals(1, state.result.length);
					assertEquals(operator.length + whitespace.length, state.pos);
					assertTrue(Std.is(state.result[0], OperatorToken));
					assertEquals(operators.get(operator), cast(state.result[0], OperatorToken).operator);
				}
			}
		}
	}
	
	private function testBad () {
		for (garbage in ["", "fmnvisfjg-", "cx. ]", "?MVCZ"]) {
			var state:TokenizeState = new TokenizeState(garbage);
			state = OperatorTokenizer.getInstance().tokenize(state);
			
			assertEquals(null, state.result);
			assertEquals(0, state.pos);
		}
	}
	
}