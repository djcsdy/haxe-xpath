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
import xpath.tokenizer.container.FunctionCallTokenizer;
import xpath.tokenizer.Token;
import xpath.Axis;
import xpath.NodeCategory;


class FunctionCallTokenizerTest extends ContainerTokenizerTestBase {

	public function new () {
		super(FunctionCallTokenizer.getInstance());
	}
	
	private function testEmpty () {
		doGoodTest("abc()", [
			cast(new BeginFunctionCallToken("abc"), Token),
			new EndFunctionCallToken()
		]);
	}
	
	private function testNumber () {
		doGoodTest("f(123)", [
			cast(new BeginFunctionCallToken("f"), Token),
			new BeginExpressionToken(), new NumberToken(123),
			new EndExpressionToken(), new EndFunctionCallToken()
		]);
	}
	
	private function testLiteral () {
		doGoodTest("gsg('dfasg')", [
			cast(new BeginFunctionCallToken("gsg"), Token), new BeginExpressionToken(),
			new LiteralToken("dfasg"), new EndExpressionToken(), new EndFunctionCallToken()
		]);
	}
	
	private function testFunction () {
		doGoodTest("gsji(gjk())", [
			cast(new BeginFunctionCallToken("gsji"), Token), new BeginExpressionToken(),
			new BeginFunctionCallToken("gjk"), new EndFunctionCallToken(),
			new EndExpressionToken(), new EndFunctionCallToken()
		]);
	}
	
	private function testVariable () {
		doGoodTest("sg($jdf)", [
			cast(new BeginFunctionCallToken("sg"), Token), new BeginExpressionToken(),
			new VariableReferenceToken("jdf"), new EndExpressionToken(),
			new EndFunctionCallToken()
		]);
	}
	
	private function testGroup () {
		doGoodTest("gsjgs((123))", [
			cast(new BeginFunctionCallToken("gsjgs"), Token), new BeginExpressionToken(),
			new BeginGroupToken(), new BeginExpressionToken(), new NumberToken(123),
			new EndExpressionToken(), new EndGroupToken(), new EndExpressionToken(),
			new EndFunctionCallToken()
		]);
	}
	
	private function testPath () {
		doGoodTest("do(/abc/def)", [
			cast(new BeginFunctionCallToken("do"), Token), new BeginExpressionToken(),
			new BeginPathToken(), new StepDelimiterToken(), new AxisToken(Child),
			new NameTestToken("abc"), new StepDelimiterToken(), new AxisToken(Child),
			new NameTestToken("def"), new EndPathToken(), new EndExpressionToken(),
			new EndFunctionCallToken()
		]);
	}
	
	private function testNumberPath () {
		doGoodTest("shp(123,/abc/def)", [
			cast(new BeginFunctionCallToken("shp"), Token), new BeginExpressionToken(),
			new NumberToken(123), new EndExpressionToken(), new ArgumentDelimiterToken(),
			new BeginExpressionToken(), new BeginPathToken(), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("abc"), new StepDelimiterToken(),
			new AxisToken(Child), new NameTestToken("def"), new EndPathToken(),
			new EndExpressionToken(), new EndFunctionCallToken()
		]);
	}
	
	private function testLiteralFunctionPath () {
		doGoodTest('czy("edjgijsf", fjh(), //*)', [
			cast(new BeginFunctionCallToken("czy"), Token), new BeginExpressionToken(),
			new LiteralToken("edjgijsf"), new EndExpressionToken(), new ArgumentDelimiterToken(),
			new BeginExpressionToken(), new BeginFunctionCallToken("fjh"), new EndFunctionCallToken(),
			new EndExpressionToken(), new ArgumentDelimiterToken(), new BeginExpressionToken(),
			new BeginPathToken(), new StepDelimiterToken(), new AxisToken(DescendantOrSelf),
			new TypeTestToken(Node), new StepDelimiterToken(), new AxisToken(Child),
			new NameTestToken("*"), new EndPathToken(), new EndExpressionToken(),
			new EndFunctionCallToken()
		]);
	}

	private function testJunk () {
		doBadTest("asdjg(");
		doBadTest("sgsdgj");
		doBadTest("gjs)");
	}
	
}
