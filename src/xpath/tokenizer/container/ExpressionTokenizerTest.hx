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


package xpath.tokenizer.container;
import xpath.tokenizer.container.ContainerTokenizerTestBase;
import xpath.tokenizer.container.OperandTokenizerTest;
import xpath.tokenizer.container.ExpressionTokenizer;
import xpath.tokenizer.Token;
import xpath.Operator;
import xpath.Axis;
import xpath.NodeCategory;


class ExpressionTokenizerTest extends ContainerTokenizerTestBase {
	
	public function new () {
		super(ExpressionTokenizer.getInstance());
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
		doGoodTest("'hello' - /", [
			cast(new BeginExpressionToken(), Token),
			new LiteralToken("hello"), new OperatorToken(Minus),
			new BeginPathToken(), new StepDelimiterToken(),
			new EndPathToken(), new EndExpressionToken()
		]);
	}
	
	private function testOperation2 () {
		doGoodTest("/AAA/EEE | //BBB", [
			cast(new BeginExpressionToken(), Token),
			new BeginPathToken(), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("AAA"),
			new StepDelimiterToken(), new AxisToken(Child),
			new NameTestToken("EEE"), new EndPathToken(),
			new OperatorToken(Union), new BeginPathToken(),
			new StepDelimiterToken(),
			new AxisToken(DescendantOrSelf),
			new TypeTestToken(Node), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("BBB"),
			new EndPathToken(), new EndExpressionToken()
		]);
	}
	
	private function testOperation3 () {
		doGoodTest("/html/body/p != ---'div'/a", [
			cast(new BeginExpressionToken(), Token),
			new BeginPathToken(), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("html"),
			new StepDelimiterToken(), new AxisToken(Child),
			new NameTestToken("body"), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("p"),
			new EndPathToken(), new OperatorToken(NotEqual),
			new BeginPathToken(), new BeginExpressionToken(),
			new NegationOperatorToken(), new NegationOperatorToken(),
			new NegationOperatorToken(), new LiteralToken("div"),
			new EndExpressionToken(), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("a"),
			new EndPathToken(), new EndExpressionToken()
		]);
	}
	
	private function testNegatePath () {
		doGoodTest("-/", [
			cast(new BeginExpressionToken(), Token),
			new NegationOperatorToken(), new BeginPathToken(),
			new StepDelimiterToken(), new EndPathToken(),
			new EndExpressionToken()
		]);
	}
	
	private function testJunk () {
		doBadTest("|/gjs");
		doBadTest("+3");
	}
	
}
