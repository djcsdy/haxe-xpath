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


package xpath.tokenizer.container;
import xpath.tokenizer.container.ContainerTokenizerTestBase;
import xpath.tokenizer.container.OperandTokenizer;
import xpath.tokenizer.Token;
import xpath.Operator;
import xpath.Axis;


class FilterOperandTokenizerTest extends ContainerTokenizerTestBase {
	
	public function new () {
		super(FilterOperandTokenizer.getInstance());
	}
		
	private function testNumber () {
		doGoodTest("123", [cast(new NumberToken(123), Token)]);
		doGoodTest("123.456", [cast(new NumberToken(123.456), Token)]);
		doGoodTest(".456", [cast(new NumberToken(0.456), Token)]);
	}
	
	private function testLiteral () {	
		doGoodTest("''", [ cast(new LiteralToken(""), Token)]);
		doGoodTest("'sjgsg'", [ cast(new LiteralToken("sjgsg"), Token)]);
		doGoodTest('""', [ cast(new LiteralToken(""), Token)]);
		doGoodTest('"sjgsg"', [ cast(new LiteralToken("sjgsg"), Token)]);
	}
	
	private function testGroup () {	
		doGoodTest("(123+456.789)", [
			cast(new BeginGroupToken(), Token), new BeginExpressionToken(),
			new NumberToken(123), new OperatorToken(Plus), new NumberToken(456.789),
			new EndExpressionToken(), new EndGroupToken()
		]);
	}
	
	private function testFunction () {	
		doGoodTest("sgjo()", [
			cast(new BeginFunctionCallToken("sgjo"), Token), new EndFunctionCallToken()
		]);
		doGoodTest("func(/a)", [
			cast(new BeginFunctionCallToken("func"), Token), new BeginExpressionToken(),
			new BeginPathToken(), new StepDelimiterToken(), new AxisToken(Child), new NameTestToken("a"),
			new EndPathToken(), new EndExpressionToken(), new EndFunctionCallToken()
		]);
	}
	
}
