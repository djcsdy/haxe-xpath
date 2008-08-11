/* haXe XPath
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


package xpath.tokenizer.token;
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.token.OperatorTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;
import xpath.Operator;


class OperatorTokenizerTest extends TestCase {
	
	var operators :Hash<Operator>;
	
	
	public function new () {
		super();
		operators = new Hash<Operator>();
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

	function testGood () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["", "fmnvisfjg-", "cx. ]", "?MVCZ"]) {
				for (operator in operators.keys()) {
					var input = new TokenizerInput(operator + whitespace + garbage);
					var output = OperatorTokenizer.getInstance().tokenize(input);
					
					assertEquals(1, output.result.length);
					assertEquals(operator.length + whitespace.length, output.characterLength);
					assertTrue(Std.is(output.result[0], OperatorToken));
					assertEquals(operators.get(operator), cast(output.result[0], OperatorToken).operator);
				}
			}
		}
	}
	
	function testBad () {
		for (garbage in ["", "fmnvisfjg-", "cx. ]", "?MVCZ"]) {
			var input = new TokenizerInput(garbage);
			
			var caught = false;
			try {
				OperatorTokenizer.getInstance().tokenize(input);
			} catch (exception:ExpectedException) {
				caught = true;
				assertEquals(0, exception.position);
			}
			assertTrue(caught);
		}
	}
	
}
