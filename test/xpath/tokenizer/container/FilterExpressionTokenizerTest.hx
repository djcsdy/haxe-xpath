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
import xpath.tokenizer.Token;


class FilterExpressionTokenizerTest extends ContainerTokenizerTestBase {
	
	public function new () {
		super(FilterExpressionTokenizer.getInstance());
	}	
	
	private function testNumber () {
		doGoodTest("123", [
			cast(new BeginExpressionToken(), Token),
			new NumberToken(123),
			new EndExpressionToken()
		]);
		doGoodTest("123.456", [
			cast(new BeginExpressionToken(), Token),
			new NumberToken(123.456),
			new EndExpressionToken()
		]);
		doGoodTest(".456", [
			cast(new BeginExpressionToken(), Token),
			new NumberToken(0.456),
			new EndExpressionToken()
		]);
	}
	
	private function testLiteral () {	
		doGoodTest("''", [
			cast(new BeginExpressionToken(), Token),
			new LiteralToken(""),
			new EndExpressionToken()
		]);
		doGoodTest("'sjgsg'", [
			cast(new BeginExpressionToken(), Token),
			new LiteralToken("sjgsg"),
			new EndExpressionToken()
		]);
		doGoodTest('""', [
			cast(new BeginExpressionToken(), Token),
			new LiteralToken(""),
			new EndExpressionToken()
		]);
		doGoodTest('"sjgsg"', [
			cast(new BeginExpressionToken(), Token),
			new LiteralToken("sjgsg"),
			new EndExpressionToken()
		]);
	}
	
	private function testGroup () {	
		doGoodTest("(123+456.789)", [
			cast(new BeginExpressionToken(), Token),
			new BeginGroupToken(), new BeginExpressionToken(),
			new NumberToken(123), new OperatorToken(Plus),
			new NumberToken(456.789), new EndExpressionToken(),
			new EndGroupToken(), new EndExpressionToken()
		]);
	}
	
	private function testFunction () {	
		doGoodTest("sgjo()", [
			cast(new BeginExpressionToken(), Token),
			new BeginFunctionCallToken("sgjo"),
			new EndFunctionCallToken(), new EndExpressionToken()
		]);
		doGoodTest("func(/a)", [
			cast(new BeginExpressionToken(), Token),
			new BeginFunctionCallToken("func"),
			new BeginExpressionToken(),	new BeginPathToken(),
			new StepDelimiterToken(), new AxisToken(Child),
			new NameTestToken("a"), new EndPathToken(),
			new EndExpressionToken(), new EndFunctionCallToken(),
			new EndExpressionToken()
		]);
	}
	
	private function testVariable () {	
		doGoodTest("$fmg", [
			cast(new BeginExpressionToken(), Token),
			new VariableReferenceToken("fmg"),
			new EndExpressionToken()
		]);
	}
	
	private function testOperation1 () {
		doIncompleteTest("'hello' - /");
	}
	
	private function testOperation2 () {
		doBadTest("/AAA/EEE | //BBB");
	}
	
	private function testOperation3 () {
		doBadTest("/html/body/p != ---'div'/a");
	}
	
	private function testNegatePath () {
		doBadTest("-/");
	}
	
	private function testJunk () {
		doBadTest("|/gjs");
		doBadTest("+3");
	}
	
}
