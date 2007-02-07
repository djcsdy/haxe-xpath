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


package xpath.unit.tokenizer.container;
import xpath.unit.tokenizer.container._TestContainerTokenizer;
import xpath.tokenizer.container.FunctionArgumentsTokenizer;
import xpath.token.Token;
import xpath.token.BeginExpressionToken;
import xpath.token.EndExpressionToken;
import xpath.token.ArgumentDelimiterToken;
import xpath.token.NumberToken;
import xpath.token.LiteralToken;
import xpath.token.BeginGroupToken;
import xpath.token.EndGroupToken;
import xpath.token.BeginFunctionCallToken;
import xpath.token.EndFunctionCallToken;
import xpath.token.VariableReferenceToken;
import xpath.token.BeginPathToken;
import xpath.token.EndPathToken;
import xpath.token.StepDelimiterToken;
import xpath.token.AxisToken;
import xpath.token.NameTestToken;
import xpath.token.TypeTestToken;


class TestFunctionArgumentsTokenizer extends _TestContainerTokenizer {
	
	public function new () {
		super(FunctionArgumentsTokenizer.getInstance());
	}
	
	private function testNumber () {
		doGoodTest("123", [
			cast(new BeginExpressionToken(), Token), new NumberToken(123), new EndExpressionToken()
		]);
	}
	
	private function testLiteral () {
		doGoodTest("'dfasg'", [
			cast(new BeginExpressionToken(), Token), new LiteralToken("dfasg"), new EndExpressionToken()
		]);
	}
	
	private function testFunction () {
		doGoodTest("gjk()", [
			cast(new BeginExpressionToken(), Token), new BeginFunctionCallToken("gjk"),
			new EndFunctionCallToken(), new EndExpressionToken()
		]);
	}
	
	private function testVariable () {
		doGoodTest("$jdf", [
			cast(new BeginExpressionToken(), Token), new VariableReferenceToken("jdf"),
			new EndExpressionToken()
		]);
	}
	
	private function testGroup () {
		doGoodTest("(123)", [
			cast(new BeginExpressionToken(), Token), new BeginGroupToken(), new BeginExpressionToken(), 
			new NumberToken(123), new EndExpressionToken(), new EndGroupToken(),
			new EndExpressionToken()
		]);
	}
	
	private function testPath () {
		doGoodTest("/abc/def", [
			cast(new BeginExpressionToken(), Token), new BeginPathToken(), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("abc"), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("def"), new EndPathToken(),
			new EndExpressionToken()
		]);
	}
	
	private function testNumberPath () {
		doGoodTest("123,/abc/def", [
			cast(new BeginExpressionToken(), Token), new NumberToken(123), new EndExpressionToken(),
			new ArgumentDelimiterToken(), new BeginExpressionToken(), new BeginPathToken(),
			new StepDelimiterToken(), new AxisToken(Child),	new NameTestToken("abc"),
			new StepDelimiterToken(), new AxisToken(Child), new NameTestToken("def"),	new EndPathToken(),
			new EndExpressionToken()
		]);
	}
	
	private function testLiteralFunctionPath () {
		doGoodTest('"edjgijsf", fjh(), //*', [
			cast(new BeginExpressionToken(), Token), new LiteralToken("edjgijsf"),
			new EndExpressionToken(), new ArgumentDelimiterToken(), new BeginExpressionToken(),
			new BeginFunctionCallToken("fjh"), new EndFunctionCallToken(), new EndExpressionToken(),
			new ArgumentDelimiterToken(), new BeginExpressionToken(), new BeginPathToken(),
			new StepDelimiterToken(), new AxisToken(DescendantOrSelf), new TypeTestToken(Node),
			new StepDelimiterToken(), new AxisToken(Child), new NameTestToken("*"),
			new EndPathToken(), new EndExpressionToken()
		]);
	}
	
	private function testJunk () {	
		doBadTest("");
		doBadTest("@");
		doBadTest("#akf");
		doBadTest(",");
	}
	
}